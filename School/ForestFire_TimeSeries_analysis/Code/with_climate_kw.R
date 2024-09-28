# 피해 면적 예측
# 피해 면적 = Trend + Seasonality + climate + err
# Trend, Seasonality로 모델링 한 이후에 값이 튀는데
# 이걸 climate 영향력으로 처리할 수 있을까?
# -> climate가 습도, 풍향, 풍속, 온도의 총체인데
#    이 모든 값을 합쳐 가장 적절한 index를 만들어낸다면?
# ex) (습도+풍속)/온도 만큼의 수치가 피해면적 - trend - seasonality를 설명할 수 있을까?

# 12-22 climate?
# 강원도 한정으로
# 평균습도 평균풍속
library(dplyr)
View(dat_kw)
unique(dat_kw$발생장소_관서)
unique(dat_kw$발생장소_시도)
unique(dat_kw$발생장소_시군구) ##
unique(dat_kw$발생장소_읍면)
unique(dat_kw$발생장소_동리)
climate_raw <- read.csv("C:/climate_kw_10y.csv",
                        fileEncoding = "euc-kr")
climate_kw <- read.csv("C:/climate_kw_10y.csv",
                       fileEncoding = "euc-kr")

climate_kw

# View(climate_kw)
tibble(climate_kw) %>%
    mutate(일시 = ym(일시)) -> climate_kw
range(climate_kw$일시)
unique(climate_kw$지점명)
unique(dat_kw$발생장소_시군구)
common_addr <- intersect(unique(climate_kw$지점명),
                         unique(dat_kw$발생장소_시군구))
dat_kw_climate <- subset(dat_kw, 발생장소_시군구 %in% common_addr)
unique(dat_kw_climate$발생장소_시군구)
common_addr
# View(dat_kw_climate) # climate 자료가 있는 강원값만 모아놓은 화재 자료
# 월별 처리해야함....

date1 <- apply(dat_kw_climate, 1, function(x){
    paste(x[1],x[2], sep='-')
})
date1
head(date1) ; str(date1) # chr structure.
date1 <- ym(date1) # ?ym()
head(date1) ; str(date1) # Convert chr to date
# ym의 경우 ymd format을 맞춰주기 위해 y-m-d 모두 표기되지만
# d가 모두 1로 고정임.
min(date1) ; max(date1)
# 강원지역, 그것도 climate가 있는 지역으로만 필터링하니까
# 2012-01 ~ 2022-12의 데이터가
# 2013-03 ~ 2022-12로 줄어든 모습
dat_kw_climate %>%
    mutate(ym = ym(paste0(발생일시_년, "-", 발생일시_월))) %>%
    group_by(ym, 발생장소_시군구) %>%
    select(ym, 발생장소_시군구, 피해면적_합계) %>%
    filter(피해면적_합계 <= 2) %>%
    mutate(fire_mean = mean(피해면적_합계)) %>%
    arrange(ym) %>%
    select(ym, 발생장소_시군구, fire_mean) %>%
    unique() -> kw_preprocess01
kw_preprocess01
kw_preprocess01 %>%
    mutate(uniq_ymloc = paste0(ym, '-', 발생장소_시군구)) -> kw_preprocess02
kw_preprocess02
# 이제 이 위의 값에서 not null for 발생장소_시군구 로 만들어줘야함 
common_addr
date_kwclimate <- seq(date("2013-01-01"), date("2022-12-31"), by="month")
dat_kw_climate_p2 <- tibble(
    date_ym = rep(date_kwclimate, each=length(common_addr)),
    addr = rep(rep(common_addr, 12), 10),
    fire_dmg = rep(0, 1200)
)
dat_kw_climate_p2 %>%
    mutate(uniq_ymloc = paste0(date_ym, '-', addr)) -> dat_kw_climate_p3
dat_kw_climate_p3
left_join(dat_kw_climate_p3, kw_preprocess02, by='uniq_ymloc') %>%
    select(uniq_ymloc, date_ym, addr, fire_dmg, fire_mean) %>%
    mutate(fire_ = ifelse(is.na(fire_mean), 0, fire_mean)) %>%
    select(uniq_ymloc, date_ym, addr, fire_) -> dat_kw_climate_p4

View(dat_kw_climate_p4)
View(climate_kw)
climate_kw %>%
    mutate(uniq_ymloc = paste0(일시, '-', 지점명)) -> climate_kw_p01
View(climate_kw_p01)
colnames(climate_kw_p01)
left_join(dat_kw_climate_p4, climate_kw_p01 , by='uniq_ymloc') %>%
    select(date_ym, addr, fire_, 평균기온..C., 평균상대습도..., 평균풍속.m.s., 평균지면온도..C.) -> dat_kw_climate_p5

dat_kw_climate_p5
View(dat_kw_climate_p5)

############################### End of kw_preprocessing










###################################################3
###################################################3
###################################################3
##################### Overview : process

# base dataset
climate_raw <- read.csv("C:/Users/p5682/Desktop/R_cloud/R_wd_2023/climate_kw_10y.csv",
                        fileEncoding = "euc-kr")
dat_raw <- readxl::read_excel(datadir, skip=1)
ym_all <- tibble(
    ym = seq(date("2013-01-01"), date("2022-12-31"), by="month"))
###################################################
###################################################
# 1. 그냥 전체에 대하여, 월별 피해량( dmgArea <= 2 filtered )
######### preprocess
# df preprocessing
dat_raw %>%
    mutate(ym = ym(paste(발생일시_년, '-', 발생일시_월)),
           피해면적_합계 = as.numeric(피해면적_합계)) %>%
    select(ym, 피해면적_합계) %>%
    filter(피해면적_합계 <= 2) %>%
    group_by(ym) %>%
    mutate(dmg_mean = mean(피해면적_합계)) %>%
    select(ym, dmg_mean) %>%
    unique() -> dmg_allregion_wip
left_join(ym_all, dmg_allregion_wip, by='ym') %>%
    mutate(dmg_mean = ifelse(is.na(dmg_mean), 0, dmg_mean)) -> dmg_allregion

dmg_allregion

# ts preprocessing
dmg_allregion.ts <- ts(dmg_allregion$dmg_mean, start=c(2013,1), frequency=12)
t.for.lm = 1:length(dmg_allregion.ts)
# trend modeling preprocessing
fit_allregion_model1 <- lm(dmg_allregion.ts ~ t.for.lm)
# seasonality modeling preprocessing
dmg_allregion_remove_trend <- dmg_allregion.ts-fit_allregion_model1$fitted.values
I = factor(cycle(dmg_allregion_remove_trend))
Imat_ = model.matrix(~I+0)
fit_allregion_model2 <- lm(dmg_allregion_remove_trend~Imat_+0)
#########
######### data frame
dmg_allregion
#########
######### ts plot
ts.plot(dmg_allregion.ts)
######### model 1 ts plot
# model 1 : z_t = T + err
ts.plot(dmg_allregion.ts, fit_allregion_model1$fitted.values,
        col=1:2, lty=1:2)
summary(fit_allregion_model1)
######### model 2 ts plot
# model 2 : z_T = T + S + err
ts.plot(dmg_allregion.ts, fit_allregion_model1$fitted.values+fit_allregion_model2$fitted.values,
        col=1:2, lty=1:2)
summary(fit_allregion_model2)
######### model 2 resid plot
ts.plot(fit_allregion_model2$residuals,
        main = '[z_t = T + S + err] model resid plot')
abline(h=0, col=2, lty=2)
acf(fit_allregion_model2$residuals, lag.max=12)
####################################################
####################################################
# 2. 강원지역에 한정해서, 월별 피해량
######### preprocess
# df preprocessing
dat_raw %>%
    mutate(ym = ym(paste(발생일시_년, '-', 발생일시_월)),
           피해면적_합계 = as.numeric(피해면적_합계)) %>%
    filter(발생장소_시도 == '강원') %>%
    select(ym, 피해면적_합계) %>%
    filter(피해면적_합계 <= 2) %>%
    group_by(ym) %>%
    mutate(dmg_mean = mean(피해면적_합계)) %>%
    select(ym, dmg_mean) %>%
    unique() -> dmg_kw_wip
left_join(ym_all, dmg_kw_wip, by='ym') %>%
    mutate(dmg_mean = ifelse(is.na(dmg_mean), 0, dmg_mean)) -> dmg_kw

dmg_kw

# ts preprocessing
dmg_kw.ts <- ts(dmg_kw$dmg_mean, start=c(2013,1), frequency=12)
t.for.lm = 1:length(dmg_kw.ts)
# trend modeling preprocessing
fit_kw_model1 <- lm(dmg_kw.ts ~ t.for.lm)
# seasonality modeling preprocessing
dmg_kw_remove_trend <- dmg_kw.ts-fit_kw_model1$fitted.values
I = factor(cycle(dmg_kw_remove_trend))
Imat_ = model.matrix(~I+0)
fit_kw_model2 <- lm(dmg_kw_remove_trend~Imat_+0)
#########
######### data frame
dmg_kw
#########
######### ts plot
ts.plot(dmg_kw.ts)
ts.plot(dmg_allregion.ts, dmg_kw.ts,
        col=c(1,3))
legend("topleft", legend=c("All region", "KangWon"),
       col = c(1, 3), lty=c(1,1))
######### model 1 ts plot
# model 1 : z_t = T + err
ts.plot(dmg_kw.ts, fit_kw_model1$fitted.values,
        col=1:2, lty=1:2)
legend("topleft", legend=c("KangWon", "trend"), col=1:2, lty=1:2)
summary(fit_kw_model1)
######### model 2 ts plot
# model 2 : z_T = T + S + err
ts.plot(dmg_kw.ts, fit_kw_model1$fitted.values+fit_kw_model2$fitted.values,
        col=1:2, lty=1:2)
legend("topleft", legend=c("KangWon", "T+S model"), col=1:2, lty=1:2)
summary(fit_kw_model2)
######### model 2 resid plot
ts.plot(fit_kw_model2$residuals,
        main = '[z_t = T + S + err] model resid plot')
abline(h=0, col=2, lty=2)
acf(fit_kw_model2$residuals, lag.max=12)
####################################################
####################################################
# 3. 기후자료가 있는 강원지역에 한해서, 월별 피해량
# 3-1. 기후자료가 있는 지역에 한해서, 지역 구분 없이 강원 자체 피해량.
######### preprocess
# df preprocessing ; View(dat_raw)
climate_addr <- unique(climate_raw$지점명)
dat_raw %>%
    mutate(ym = ym(paste(발생일시_년, '-', 발생일시_월)),
           피해면적_합계 = as.numeric(피해면적_합계)) %>%
    filter(발생장소_시도 == '강원') %>% 
    select(ym, 피해면적_합계, 발생장소_시군구) %>%
    filter(발생장소_시군구 %in% climate_addr) %>%
    filter(피해면적_합계 <= 2) %>%
    group_by(ym) %>%
    mutate(dmg_mean = mean(피해면적_합계)) %>%
    select(ym, dmg_mean) %>%
    unique() -> dmg_kw_climate_wip
dmg_kw_climate_wip
left_join(ym_all, dmg_kw_climate_wip, by='ym') %>%
    mutate(dmg_mean = ifelse(is.na(dmg_mean), 0, dmg_mean)) -> dmg_kw_climate

dmg_kw_climate

# ts preprocessing
dmg_kw_climate.ts <- ts(dmg_kw_climate$dmg_mean, start=c(2013,1), frequency=12)
t.for.lm = 1:length(dmg_kw_climate.ts)
# trend modeling preprocessing
fit_kw_climate_model1 <- lm(dmg_kw_climate.ts ~ t.for.lm)
# seasonality modeling preprocessing
dmg_kw_climate_remove_trend <- dmg_kw_climate.ts-fit_kw_climate_model1$fitted.values
I = factor(cycle(dmg_kw_climate_remove_trend))
Imat_ = model.matrix(~I+0)
fit_kw_climate_model2 <- lm(dmg_kw_climate_remove_trend~Imat_+0)
#########
######### data frame
dmg_kw
#########
######### ts plot
ts.plot(dmg_kw_climate.ts)
ts.plot(dmg_allregion.ts, dmg_kw.ts, dmg_kw_climate.ts,
        col=1:3)
legend("topleft", legend=c("All", "KW", "KW::climate"),
       col=1:3, lty=c(1,1,1))
######### model 1 ts plot
# model 1 : z_t = T + err
ts.plot(dmg_kw_climate.ts, fit_kw_climate_model1$fitted.values,
        col=1:2, lty=1:2)
legend("topleft", legend=c("KW::climate", "trend"), col=1:2, lty=1:2)
summary(fit_kw_climate_model1)
######### model 2 ts plot
# model 2 : z_T = T + S + err
ts.plot(dmg_kw_climate.ts, fit_kw_climate_model1$fitted.values+fit_kw_climate_model2$fitted.values,
        col=1:2, lty=1:2)
legend("topleft", legend=c("KW::climate", "T+S model"), col=1:2, lty=1:2)
ts.plot(dmg_kw.ts, fit_kw_model2$fitted.values+fit_kw_model1$fitted.values,
        dmg_kw_climate.ts, fit_kw_climate_model1$fitted.values+fit_kw_climate_model2$fitted.values,
        col = 1:4)
legend("topleft", legend=c("KW", "KW_model", "KW.C", "KW.C_model"),
       col=1:4, lty=1)
ts.plot(ts(fit_kw_model2$fitted.values+fit_kw_model1$fitted.values, start=c(2013,1), frequency=12),
        fit_kw_climate_model1$fitted.values+fit_kw_climate_model2$fitted.values,
        col=c("blue", "red"))
legend("topleft", legend=c("KW_model", "KW.C_model"), col=c(4,2), lty=1)
summary(fit_kw_climate_model2)
######### model 2 resid plot
ts.plot(fit_kw_climate_model2$residuals,
        main = '[z_t = T + S + err] model resid plot')
abline(h=0, col=2, lty=2)
acf(fit_kw_model2$residuals, lag.max=12)


######################################################
######################################################


# 3. 기후자료가 있는 강원지역에 한해서, 월별 피해량
# 3-2. 기후자료가 있는 지역에 한해서, 지역을 구분 및 기후값 적합.
######### preprocess
# df preprocessing ; View(dat_raw)
climate_addr <- unique(climate_raw$지점명)
climate_common <- intersect(climate_addr, dat_raw$발생장소_시군구)
dat_raw %>%
    mutate(ym = ym(paste(발생일시_년, '-', 발생일시_월)),
           피해면적_합계 = as.numeric(피해면적_합계)) %>%
    filter(발생장소_시도 == '강원') %>% 
    select(ym, 피해면적_합계, 발생장소_시군구) %>%
    filter(발생장소_시군구 %in% climate_addr) %>%
    filter(피해면적_합계 <= 2) %>%
    mutate(addr = 발생장소_시군구) %>%
    group_by(ym, addr) %>%
    mutate(dmg_mean_by.addr = mean(피해면적_합계)) %>%
    select(addr,  ym, dmg_mean_by.addr) %>%
    unique() %>%
    mutate(uniq_ymloc = paste0(addr, '/', ym)) -> dmg_kw_climate.by.addr_wip
dmg_kw_climate.by.addr_wip
ym_temp1 <- seq(date("2013-01-01"), date("2022-12-31"), by="month")
ym_all_addr <- tibble(
    ym = rep(ym_temp1, each=length(climate_common)),
    addr = rep(rep(climate_common, 12), 10)
)
# 각기 date에 대해, 10개의 addr값이 생겨야함.
# date는 10년짜리 즉, 120개의 unique date가 존재하며
# 그에 대한 10개의 addr 대응값이 생김.
ym_all_addr
ym_all_addr %>%
    mutate(uniq_ymloc = paste0(addr, '/', ym)) -> ym_all_addr
ym_all_addr
dmg_kw_climate.by.addr_wip

left_join(ym_all_addr, dmg_kw_climate.by.addr_wip, by='uniq_ymloc') %>%
    mutate(dmg_mean = ifelse(is.na(dmg_mean_by.addr), 0, dmg_mean_by.addr)) %>% 
    select(uniq_ymloc, ym.x, addr.x, dmg_mean) %>%
    mutate(ym = ym.x, addr = addr.x) %>%
    select(uniq_ymloc, ym, addr, dmg_mean) -> dmg_kw_climate.by.addr_wip2
colnames(climate_raw)
climate_raw %>% tibble() %>%
    mutate(ym = ym(일시)) %>%
    mutate(ymloc = paste0(지점명, '/', ym)) %>% 
    select(uniq_ymloc = ymloc,
           celcius = 평균기온..C.,
           humidity = 평균상대습도...,
           wind = 평균풍속.m.s.,
           surface_temp = 평균지면온도..C.) -> climate_kw_wip
dmg_kw_climate.by.addr_wip2
climate_kw_wip
inner_join(dmg_kw_climate.by.addr_wip2,
           climate_kw_wip, by='uniq_ymloc') %>% 
    select(ym, addr, dmg_mean, celcius, humidity, wind, surface_temp) -> dmg_kw_climate.by.addr
dmg_kw_climate.by.addr
View(dmg_kw_climate.by.addr)
# 어느 지역에 몇번 불이 났는가에 대한 점검
dmg_kw_climate.by.addr %>%
    group_by(addr) %>%
    mutate(addr_fireCnt = sum(ifelse(dmg_mean==0, 1, 0))) %>%
    select(addr_fireCnt)
# 70~110정도로 화재 건수가 존재.
# but,... 10년이라기엔 너무 값이 없다!

##########################
# 지금까지 모델 : z_t = T + S + err
# 원하는 모델 : z_t = T + S + C + err (C := climate indicator)
# 문제 : z_t 설정. 
# 지금까지는 피해면적으로 z_t를 했는데...
# 일단 경향을 먼저 보자.

# Problem 1 : cannot calculate := monthly
# 지역별로 나눠버려서, month에 대한 값이 10개로 불어났다.
# Solution 1. month에 대한 평균값
# Solution-Problem 1. 그러면 climate 영향력 판단이 어려움
# Advantage of Solution 1. climate 경향성은 판단 가능
# -> 그 경향성으로 dmg 경향성과 비교해볼 수 있겠다.
# -> 그 경향성으로 corr을 계산해볼 수 있겠다.

#################### preprocess as climate->monthly climate
dmg_kw_climate.by.addr
dmg_kw_climate.by.addr %>%
    group_by(ym) %>%
    mutate(dmg_mean = mean(dmg_mean),
           celcius = mean(celcius),
           humidity = mean(humidity),
           wind = mean(wind),
           surface_temp = mean(surface_temp)) %>%
    select(ym, dmg_mean, celcius, humidity, wind, surface_temp) %>%
    unique() -> dmg_kw_climate.by.addr_monthmean
dmg_kw_climate.by.addr_monthmean
