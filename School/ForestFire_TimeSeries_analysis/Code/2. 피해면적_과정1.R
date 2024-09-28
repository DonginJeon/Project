# 피해면적 TS->ts plotting and fitting problem

# 모델을 고려해보자
# 피해면적 = 트렌드 + 월별 시즈널리티
# 이 모델은, 피해 면적이 트렌드와 시즈널리티로 설명할 수 있다는 모델
# 부족한점은, 역시 이상치 처리 문제겠지.
date_all <- seq(date("2013-01-01"), date("2022-12-31"), by="day")
date_ts <- as.ts(date_all)

{ # 화재 없는 날짜까지 포괄하는 피해면적 데이터
    dat_ymd_dmgArea %>%
        select(fireDate, dmgAreaMean) %>%
        unique() %>%
        arrange(fireDate) -> temp001
    temp001
    temp002 <- temp001$fireDate ; head(temp002)
    latest = 1
    dmgAreaMeanAll <- rep(0, length.out=length(date_all))
    head(date_all)
    for(i in 1:length(date_all)) {
        if(date_all[i] == temp002[latest]) {
            dmgAreaMeanAll[i] = temp001$dmgAreaMean[latest]
            latest = latest + 1
        } else {
            dmgAreaMeanAll[i] = 0
        }
    }
}
dmgAreaMeanAll
tibble(
    date = date_all,
    date_ts = date_ts,
    dmgAreaMean = dmgAreaMeanAll
) %>% 
    filter(dmgAreaMeanAll>0)
temp001
# 흠 잘 구현됐네
date_dmg_table <- tibble(
    date = date_all,
    date_ts = date_ts,
    dmgAreaMean = dmgAreaMeanAll,
    dmgAreaMean_xoutlier = ifelse(dmgAreaMeanAll>2, 0, dmgAreaMeanAll)
) # 2이상은 0으로 만들어서 outlier 처리.
# date_dmg_table %>%
#     filter(date<date("2015-01-01")) -> temp003
# ts_dam_xoutlier <- 
#     ts.plot(temp003$dmgAreaMean_xoutlier)
# ts.plot(date_dmg_table$dmgAreaMean_xoutlier)
# fit001 <- lm(dmgAreaMean_xoutlier~date_ts,data = date_dmg_table)
# summary(fit001)

# TS plot fitting 하는데 뭔가 좀 잘 안되서 따로 보려고 함.
# 일단, 2013, 2014년만 보고
# 그래도 값이 좀 이상하게 나오거나 plot이 잘 안보이면
# day단위가 아닌 month 단위로 진행하려고 함.
date_dmg_table %>%
    filter(date < date("2015-01-01")) %>%
    select(date, dmgAreaMean_xoutlier) -> temp004
temp004
ts_dam <- ts(temp004$dmgAreaMean_xoutlier,
             start=c(2013,1), frequency=365)
ts_dam
ts.plot(ts_dam) # 일단, 2년으로 제한하니까 비교적 plotting이 된 모습.,
t <- 1:length(ts_dam)

# 1차 : 선형 모델링 ( 트렌드 체크 )
fit001 <- lm(ts_dam ~ t)
ts.plot(ts_dam, fit001$fitted.values,
        col = 1:2, lty = 1:2)
summary(fit001) # 매우 미미하지만 감소 트렌드 존재.
# 트렌드 피팅 값을 얻어냈음. 이제... seasonality 확인
ts_dam_R.trend <- ts_dam-fit001$fitted.values
S001 <- factor(cycle(ts_dam_R.trend))
Smat001 <- model.matrix(~S001+0)
fit002 <- lm(ts_dam_R.trend ~ Smat001 + 0)
summary(fit002)
ts.plot(fit002$fitted.values)
# seasonality를 적합시키려면 monthly로 봐야하는데,
# daily로 적합시켜서 과적합 문제가 생김
# 애당초 목적을 생각해보자
# Goal : 피해 면적을 잘 설명하기
# -> 즉, 피해 면적에 영향을 주는게 무엇인지 가장 
#    잘 설명할 수 있는 모델을 찾기
# ts frequency를 daily로 설정하는거 자체가 잘못됨
# 피해면적 = trend + seasonality Indicator(monthly) + err
# 모델을 기초로 재적합 해보겠음
dat_ymd_dmgArea
