# Ts fitting with monthly frequency
# 다시 월별로 거시기 해줘야하는데...
date1 <- apply(dat_raw, 1, function(x){
    paste(x[1],x[2], sep='-')
})
date1
head(date1) ; str(date1) # chr structure.
date1 <- ym(date1) # ?ym()
head(date1) ; str(date1) # Convert chr to date
# ym의 경우 ymd format을 맞춰주기 위해 y-m-d 모두 표기되지만
# d가 모두 1로 고정임.
min(date1) ; max(date1)
dat_ymd_dmgArea <- tibble(
    fireDate = date1,
    dmgArea = dat_1$피해면적_합계
)
dat_ymd_dmgArea
# ㅇㅋ

dat_ymd_dmgArea %>%
    group_by(fireDate) %>%
    filter(dmgArea<=2) %>%
    mutate(dmgAreaMean = mean(dmgArea)) %>%
    select(fireDate, dmgAreaMean) %>%
    unique() %>%
    arrange(fireDate) -> temp005
temp005 # 2 이하값만 살리고 평균낸 df
###
###
sort(unique(date1))
date_sequence <- seq(date("2013-01-01"), date("2022-12-12"), by = "month")
tibble(fireDate = date_sequence) %>%
    left_join(temp005, by="fireDate") %>%
    mutate(dmgAreaMean=ifelse(is.na(dmgAreaMean), 0, dmgAreaMean)) -> temp006
temp006
year_factor <- factor(rep(2013:2022, each=12))
month_factor <- factor(rep(1:12, 10))
temp006 %>%
    add_column(year = year_factor) %>%
    add_column(month = month_factor) -> temp007
temp007 %>% ggplot() +
    geom_line(aes(x=month, y=dmgAreaMean, group=year, col=year, linetype=year))
# Seasonality가 명확한듯 하면서 명확하지 않음...
# 피해면적 outlier 처리를 다시 해야하나?
# 빈도를 따르는 것 같으면서도, 애매하게 따르질 않음.
###
###
ts.dam <- ts(temp007$dmgAreaMean, start=(2013), frequency=12)
ts.dam
ts.plot(ts.dam)
t = 1:length(ts.dam)
fit003 <- lm(ts.dam~t) # 피해면적 = T model
ts.plot(ts.dam, fit003$fitted.values,
        col=1:2, lty=1:2)
summary(fit003)
# trend가 거의 없는 것으로 보인다.

ts.dam_R.trend <- ts.dam-fit003$fitted.values
I = factor(cycle(ts.dam_R.trend))
Imat_ = model.matrix(~I+0)
fit004 <- lm(ts.dam_R.trend~Imat_+0)
ts.plot(ts.dam, fit004$fitted.values+fit003$fitted.values,
        col=1:2, lty=1:2) # seasonality가 잘 빠진?
# 좀 값이 극단적으로 튀는 느낌이 있음...
summary(fit004)
# p.value가 전체적으로 값이 별로임
ts.plot(fit004$residuals)
abline(h=0, col=2)
acf(fit004$residuals, lag.max=12)
pacf(fit004$residuals, lag.max=12)
# 막상 자기상관은 약하게 나오네?

ts.plot(ts.dam, fit004$fitted.values+fit003$fitted.values,
        col=1:2, lty=1:2) # seasonality가 잘 빠진?
qqnorm(fit004$residuals)
qqline(fit004$residuals, col=2, lty=2)
nortest::ad.test(fit004$residuals)
# 왼쪽 꼬리가 좀 두꺼워보인다.