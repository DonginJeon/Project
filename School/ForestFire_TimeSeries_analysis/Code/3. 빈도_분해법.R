#
tibble(dat_raw)
View(dat_raw)
# 이전 경험을 토대로, 월별로 정리하고자 함.
dat_raw %>%
    select(발생일시_년, 발생일시_월, 발생장소_시도) -> cnt001
cnt001 %>%
    mutate(month = factor(as.numeric(발생일시_월)),
           year = factor(as.numeric(발생일시_년)),
           loc = factor(발생장소_시도)) %>%
    select(year, month, loc) %>%
    group_by(month) -> cnt002

cnt002 %>%
    group_by(year, month) %>% count() -> cnt003

cnt003 %>%
    mutate(ym = as.Date(paste0(year, "-", month, "-", "01"))) -> cnt004
cnt004

date_sequence <- seq(date("2013-01-01"), date("2022-12-12"), by = "month")
tibble(ym = date_sequence) %>%
    left_join(cnt004, by="ym") %>%
    mutate(n = ifelse(is.na(n), 0, n),
           year=factor(lubridate::year(ym)),
           month=factor(lubridate::month(ym))) -> cnt005
cnt005
## 월별 발생 빈도 그래프
cnt005 %>% ggplot() +
    geom_line(aes(x=month, y=n, group=year, color=year))
## 피해 면적과 다르게, 명확하게 비교되는 모습

## 피팅 : 분해법
cnt006 <- ts(cnt005$n, start=c(2013,1), frequency=12)
ts.plot(cnt006)
t <- 1:length(cnt006)
fitCnt001 <- lm(cnt006~t)
summary(fitCnt001)
ts.plot(cnt006, fitCnt001$fitted.values,
        col=1:2, lty=1:2)
# 추세는 증가 추세가 존재?
fitCnt002 <- cnt006 - fitCnt001$fitted.values
I = factor(cycle(fitCnt002))
Imat_ = model.matrix(~I+0)
fitCnt003 <- lm(fitCnt002~Imat_+0)
ts.plot(cnt006, fitCnt001$fitted.values+fitCnt003$fitted.values,
        col=1:2, lty=1:2) # 괜찮아보이는 적합.
summary(fitCnt003)
# mse나 pvalue는 좀 애매해보이는것같기도 하고
acf(fitCnt003$residuals, lag.max=12)
pacf(fitCnt003$residuals, lag.max=12)
# 12에서 상관이 있는 것 같은?