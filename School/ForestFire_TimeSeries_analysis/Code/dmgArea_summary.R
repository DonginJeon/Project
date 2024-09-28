rm(list=ls())



dat_clim <- read.csv("c:/fire_climate.csv", header = T, sep=",",encoding = "UTF-8") %>%
    tibble() %>%
    select(-X) %>%
    mutate(date = ymd_hm(substr(date, 1, 16)))
clim_all_raw <- read.csv("C:/clim_all_raw.csv",fileEncoding = "euc-kr")
# dat_clim : 강원지역 화재 피해량 dataset
# 화재 발생 당시 측정된 celcius, wind, humidity, atm, surf_celcius 자료가 포함됨.
dat_clim

# 1. 단순 분해법 적합
# 피해면적 = trend + seasonality 모델 적합해보기

# 피해면적을 일별로 적합하려면 생기는 문제 :
# -> 피해 면적이 없는 day도 존재함(화재 발생 X)
# -> 피해 면적이 없을경우, 기후 요소를 어떻게 적용할 것인가?
# 대안 : 월별로 평균을 내려고 함.

# 월별로 평균을 내서 적합하면 발생하는 문제 : 
# -> 불 날때 당시 기후가 피해 면적에 중요한데, 그걸 반영하지 못함. 월 평균이라서.
# -> '평균'이라서 robust하지 못함.
# 대안 : 이상치는 대체해준다. robust하도록.
# 일단, 좀 더 직관적인 그래프가 그려지는 [월 평균 피해량]으로 진행하려고 함.



###### model 1 : 그냥 Trend + Seasonality


### start : 전처리
month_all <- tibble(y = rep(2013:2022, each=12), m = rep(1:12, times=10)) %>%
    mutate(ym = ym(paste0(y, '-', m))) %>% select(ym)
dat_clim %>%
    mutate(ym = paste0(year(date), '-', month(date))) %>%
    mutate(ym = ym(ym)) %>%
    select(ym, dmg) %>%
    mutate(dmg = ifelse(dmg >= 1.4, 1.4, dmg)) %>%
    group_by(ym) %>%
    mutate(dmg = mean(dmg)) %>%
    unique() %>%
    left_join(month_all, ., by='ym') %>%
    mutate(dmg = ifelse(is.na(dmg), 0, dmg)) -> dat_month
dat_month
dat_clim
dmg_month_ts <- ts(dat_month$dmg, start=c(2013, 1), frequency=12)
t_ts = 1:length(dat_month$dmg)
I <- factor(cycle(dmg_month_ts))
Imat_ <- model.matrix(~I+0)
# 적합.
model_dmg_TS <- lm(dmg_month_ts ~ t_ts + Imat_ + 0)
### end : 전처리



### start : TS 모델링 분석
# model : dmg = trend + seasonality + epsilon
# 적합 통계량
summary(model_dmg_TS)
# 적합 그래프
ts.plot(dmg_month_ts, model_dmg_TS$fitted.values,
        col=1:2, lty=1:2)
# 잔차 그래프
ts.plot(model_dmg_TS$residuals)
abline(h=0, col=2, lty=2)
acf(model_dmg_TS$residuals)
pacf(model_dmg_TS$residuals)
qqnorm(model_dmg_TS$residuals)
qqline(model_dmg_TS$residuals, col=2)
# 잔차 통계량
nortest::ad.test(model_dmg_TS$residuals)
t.test(model_dmg_TS$residuals)
### end : TS 모델링 분석



### start : 자료 전처리
colnames(clim_all_raw) <- c("x","loc_id", "loc_name", "date", "celcius", "wind", "humid", "atm", "surf")
# 연도+월별 기상
clim_all_raw
clim_all_raw %>%
    filter(!if_any(everything(), is.na)) %>%
    mutate(date = ymd_hm(date)) %>%
    mutate(ym = paste0(year(date), '-', month(date))) %>%
    group_by(ym) %>%
    mutate(celcius = mean(celcius),
           wind = mean(wind),
           humid = mean(humid),
           atm = mean(atm),
           surf = mean(surf)) %>%
    select(ym, celcius, wind, humid, atm, surf) %>%
    unique() %>%
    mutate(ym = ym(ym)) -> clim_bymonth
clim_bymonth
dat_month
dmg_clim_bymonth <- inner_join(clim_bymonth, dat_month, by='ym')
dmg_clim_bymonth
plot_all <- ggplot(dmg_clim_bymonth)
p_cel_all <- plot_all +
    geom_line(aes(x=ym, y=celcius))
p_wind_all <- plot_all +
    geom_line(aes(x=ym, y=wind))
p_humid_all <- plot_all +
    geom_line(aes(x=ym, y=humid))
p_atm_all <- plot_all +
    geom_line(aes(x=ym, y=atm))
p_surf_all <- plot_all +
    geom_line(aes(x=ym, y=surf))
p_dmg_bymonth <- plot_all +
    geom_line(aes(x=ym, y=dmg))
# dmg와 기상 plot by ym
p_cel_dmg_ym <- plot_all +
    geom_point(aes(x=dmg, y=celcius))
p_wind_dmg_ym <- plot_all +
    geom_point(aes(x=dmg, y=wind))
p_humid_dmg_ym <- plot_all +
    geom_point(aes(x=dmg, y=humid))
p_atm_dmg_ym <- plot_all +
    geom_point(aes(x=dmg, y=atm))
p_surf_dmg_ym <- plot_all +
    geom_point(aes(x=dmg, y=surf))
# just 월별 기상
clim_all_raw %>%
    filter(!if_any(everything(), is.na)) %>%
    mutate(date = ymd_hm(date)) %>%
    mutate(m = month(date)) %>%
    group_by(m) %>%
    mutate(celcius = mean(celcius),
           wind = mean(wind),
           humid = mean(humid),
           atm = mean(atm),
           surf = mean(surf)) %>%
    select(m, celcius, wind, humid, atm, surf) %>%
    unique()-> clim_onlymonth
clim_onlymonth
dat_clim %>%
    filter(dmg <= 500) %>%
    mutate(dmg = ifelse(dmg >= 1.4, 1.4, dmg)) %>%
    mutate(m = month(date)) %>%
    group_by(m) %>%
    mutate(dmg = mean(dmg)) %>%
    select(m, dmg) %>%
    unique() -> dmg_onlymonth
dmg_onlymonth
dmg_clim_onlymonth <- left_join(dmg_onlymonth, clim_onlymonth, by='m')
plot_onlymonth <- ggplot(dmg_clim_onlymonth)
p_cel_onlymonth <- plot_onlymonth +
    geom_line(aes(x=m, y=celcius))
p_wind_onlymonth <- plot_onlymonth +
    geom_line(aes(x=m, y=wind))
p_humid_onlymonth <- plot_onlymonth +
    geom_line(aes(x=m, y=humid))
p_atm_onlymonth <- plot_onlymonth +
    geom_line(aes(x=m, y=atm))
p_surf_onlymonth <- plot_onlymonth +
    geom_line(aes(x=m, y=surf))
p_dmg_onlymonth <- plot_onlymonth +
    geom_line(aes(x=m, y=dmg))
# dmg ~ climate 플롯 just 월별
p_cel_dmg_onlymonth <- plot_onlymonth +
    geom_point(aes(x=dmg, y=celcius))
p_wind_dmg_onlymonth <- plot_onlymonth +
    geom_point(aes(x=dmg, y=wind))
p_humid_dmg_onlymonth <- plot_onlymonth +
    geom_point(aes(x=dmg, y=humid))
p_atm_dmg_onlymonth <- plot_onlymonth +
    geom_point(aes(x=dmg, y=atm))
p_surf_dmg_onlymonth <- plot_onlymonth +
    geom_point(aes(x=dmg, y=surf))
### end : 자료 전처리

### start : TS 모델링 해석
# 적합 통계량을 봤을 때, 
# 트렌드와 2,3,4월에 대한 계수 pvalue가 작다.
# 다시말해, 트렌드와 2,3,4월에 대해 적합 신뢰도가 높다.

# 적합 그래프를 봤을 때, 
# 계절성 흐름은 잘 반영한 것 같지만
# 좀 튀는 값들에 대한 적합이 잘 안된 것 같다.

# 잔차 그래프를 봤을 때, 
# normal은 아닌 것 같다.
# t-test결과를 보니 평균이 0인건 맞는 것 같다.
# 자기상관이 11에 있지만, 유의할 수준인가? 잘 모르겠다.

### end : TS 모델링 해석



###### model 2 : Trend + Seasonality + Climate
### 기후 요소 적용 과정

# 일단 climate의 흐름을 보자. dmg와 공통점을 찾을 수 있지 않을까?



### start : 기후 EDA
# plot
grid.arrange(p_cel_all, p_wind_all, p_humid_all, 
             p_atm_all, p_surf_all, p_dmg_bymonth, nrow=3)
grid.arrange(p_cel_dmg_ym, p_wind_dmg_ym, p_humid_dmg_ym,
             p_atm_dmg_ym, p_surf_dmg_ym, p_dmg_bymonth, nrow=3)
grid.arrange(p_cel_onlymonth, p_wind_onlymonth,
             p_humid_onlymonth, p_atm_onlymonth,
             p_surf_onlymonth, p_dmg_onlymonth, nrow=3)
grid.arrange(p_cel_dmg_onlymonth, p_wind_dmg_onlymonth,
             p_humid_dmg_onlymonth, p_atm_dmg_onlymonth,
             p_surf_dmg_onlymonth, p_dmg_onlymonth, nrow=3)
# statistics
corr.visible(dmg_clim_bymonth[,2:7])
corr.visible(dmg_clim_onlymonth[,2:7])
### end : 기후 EDA



### start : 기후 해석
# 연+월 기준으로 보면, 모두 계절성이 보인다.
# 그래프로 봤을 땐 dmg와 가장 연관있는 요소 찾기가 어려워 보인다.
# corr을 보면, 그나마 humid가 선형관계가 있다.
# dmg~climate 플롯을 보면 로그관계처럼 보이기도 한다.
# 정확히는 로그관계보다는, 특정 범위에서 큰 값을 공통적으로 보이는 경향이 있는 것 같다.
# dmg는 0.5가 어떤 threshold로 정해진 것 같아보인다.
# dmg는 max 1.4로 필터링된 상태임을 감안해도, 특이해보인다.

# 월별 기준으로 보자.
# wind와 dmg가 월별 수치가 비슷하게 보인다.
# 실제로 climate ~ dmg 그래프를 보면, wind와 dmg가 나름 선형관계를 가지는 것 처럼 보인다.
# celcius, humid, surf는 dmg가 0.2~0.3인 구간에서는 전체적으로 퍼져있지만
# dmg가 높은 구간(0.3~0.4)에서는 humid가 낮고 celcius가 낮은 경향을 보인다.
# 실제로 correlation도 wind와 0.7정도의 값을 보이고, humid와 0.6의 값을 보인다.
# 다만 wind와 humid가 0.8의 연관성을 보이기 때문일수도 있다.
### end : 기후 해석

###
# wind를 모델에 적합시켜보자.

# model : dmg ~ T + S + Wind + error
model_dmg_TSW <- lm(dmg_month_ts ~ t_ts + Imat_ + dmg_clim_bymonth$wind + 0)
# 모델 그래프
ts.plot(dmg_month_ts, model_dmg_TS$fitted.values, model_dmg_TSW$fitted.values,
        col=1:3, lty=1:3)
# 모델 통계량
summary(model_dmg_TSW)
# 딱히 유의미한 변화를 유도할 수 없음.



### 왜 group으로 나눠서 분석했는가?
# 분명 dmg를 분석하면, 
quantile(dat_clim$dmg, seq(0, 1, by=0.1))
sum(dat_clim$dmg > 1.4) ; length(dat_clim$dmg)
# 0.5는 백분위 80짜리 값인데 왜 그래프에 6개밖에 없는가?
# 6/120 = 0.05
# 일별로 보면 0.5이상의 피해량은 전체 피해량의 상위 20%인데,
# 월별로 보면 0.5이상의 피해량은 전체 피해량의 상위 5%이다.
# 이것은 dmg가 robust하지 않기 때문이다.
# dmg를 월별로 평균내기 때문에, robust한 결과를 도출하기 위해
# indexing을 통해 robust한 적합을 시도하고자 함.
# 상위 90% 밸류인 피해량 1.4를 기준으로 삼겠음.


# 애초에 기후 설명변수로 들어간 산불 피해량 모델이라는게
# "이러한 기후 조건 하에서는 산불 피해량이 높다/낮다"
# 를 설명하는 모델인데, 이 값이 연속적인 값으로 설명이 된다는 것이었음.
# 하지만 이 모델이 "월평균 산불피해량"을 설명하므로, 
# 1. 산불 피해량 자체가 robust하지 못한데 '평균'을 사용하는 문제점
# 2. '월'단위를 사용하므로 산불 당시의 기상을 고려하지 못하는 문제점.
# 하지만 시간 단위로 시계열 자료분석을 진행한다면
ts.plot(ts(dmg_maxlimit))
abline(h=0, col=2)
# 이런 직관적이지 못한 데이터 + 동일하게 분포하지 않는 시간값
# 의 문제가 있으므로, 월별로 진행한다.
# 그리고 robust문제를 해결하기 위해 index를 진행한다.


# 바람과 피해량의 상관관계
# 높은 피해량과 바람의 상관관계가 있을까?
# 1.4는 피해량의 90분위수, 4.5는 바람의 90분위수.
# 풍속 4.5 이상을 '강풍', 4.5 이하를 '약풍'으로 정의하겠다.
# 피해량 1.4 이상을 '심각', 피해량 1.4 이하를 '경미'로 정의하겠다.

dat_clim %>%
    select(dmg, adj_wind) %>%
    filter(dmg >= 1.4) %>%
    filter(adj_wind >= 4.5)
# 피해량 '심각' 47 에서 '강풍'은 13, '약풍'은 34
dat_clim %>%
    select(dmg, adj_wind) %>%
    filter(dmg < 1.4) %>%
    filter(adj_wind >= 4.5)
# 피해량 '경미' 406에서 '강풍'은 34 '약풍'은 372
contin_wind = matrix(c(372, 34, 34, 13), nrow=2)
colnames(contin_wind) = c("dmg_little", "dmg_lot")
rownames(contin_wind) = c("wind_little", "wind_lot")
contin_wind
fisher.test(contin_wind)
# 검정 결과 : 귀무가설 기각.
# 둘 사이에 연관이 있다.
# 이로써, 바람과 피해량이 관계가 있다라고 말할 수 있음.

# 이런식으로, 기상요소를 적용시킬것임.
# 먼저, 월별 연관성이 관측되었던 바람과 습도만 그룹화하려고 한다.
# 우리의 직관과도 맞는다. 바람이 많이 불면 불이 잘 퍼지고, 건조하면 불이 잘 퍼진다.

### start : 자료 전처리
library(dplyr)

dat_clim %>%
    mutate(dmg = ifelse(dmg >= 1.4, 1.4, dmg)) %>%
    .$dmg -> dmg_maxlimit

clim_all <- clim_all_raw
colnames(clim_all) = c("x","loc_id", 'loc_name', 'date', 'celcius', 'wind', 'humid', 'hpa', 'surf')
clim_all %>%
    filter(!if_any(everything(), is.na)) %>%
    reframe(quantile = seq(0, 1, by=0.1),
            q_all_cel = quantile(celcius, probs=seq(0, 1, by=0.1)),
            q_all_wind = quantile(wind, probs=seq(0, 1, by=0.1)),
            q_all_humid = quantile(humid, probs=seq(0, 1, by=0.1)),
            q_all_hpa = quantile(hpa, probs=seq(0, 1, by=0.1)),
            q_all_surf = quantile(surf, probs=seq(0, 1, by=0.1))) -> q_all
dat_clim %>%
  filter(!if_any(everything(), is.na)) %>%
    reframe(quantile = seq(0, 1, by=0.1),
            q_dmg = quantile(dmg, probs=seq(0, 1, by=0.1)),
            q_cel = quantile(adj_celcius, probs=seq(0, 1, by=0.1)),
            q_wind = quantile(adj_wind, probs=seq(0, 1, by=0.1)),
            q_humid = quantile(adj_humidity, probs=seq(0, 1, by=0.1)),
            q_hpa = quantile(adj_atm, probs=seq(0, 1, by=0.1)),
            q_surf = quantile(adj_surf, probs=seq(0, 1, by=0.1))) -> q_fired
q_all
q_fired
colnames(dat_clim) = c("date", "dmg", "loc", "cel" ,"wind", "humid", "atm", "surf")
##########3 피셔 테스트
dat_clim
fisher_matrix = list()
fisher_result = list()
for(i in 2:10) {
    dat_clim %>%
        select(-loc) %>%
        filter(dmg <= 500) %>%
        mutate(dmg_lower = ifelse(dmg <= q_fired$q_dmg[10], 'd_lower', 'd_upper')) %>%
        mutate(cli_lower = ifelse(cel <= q_fired$q_cel[i], 'c_lower', 'c_upper')) %>%
        group_by(dmg_lower, cli_lower) %>%
        summarise(n=n(), .groups='keep') -> wip_summary
    if(nrow(wip_summary) != 4){fisher_matrix[[i]] = 0; next}
    wip_summary_matrix <- matrix(wip_summary$n, nrow=2)
    colnames(wip_summary_matrix) = unique(wip_summary$dmg_lower) 
    rownames(wip_summary_matrix) = unique(wip_summary$cli_lower)
    fisher_matrix[[i]] = wip_summary_matrix
    fisher_result[[i]] = fisher.test(wip_summary_matrix)
}
# names(fisher_matrix) = seq(0, 0.9, by=0.1)
# names(fisher_result) = seq(0, 0.9, by=0.1)
fisher_matrix
fisher_result
# for loop 기준 5번째 코드인
# mutate(cli_lower = ifelse(wind <= q_fired$q_wind[i], 'c_lower', 'c_upper')) %>%
# 여기서 wind, q_wind부분만 다른 기상으로 바꿔주면서 피셔테스트 검정 가능.

# dmg의 high/low 기준을 1.4로 고정하고,
# wind와 humidity의 10~90백분위수로 변경하면서 가장 fisher.test의 p.value가
# 작은 값을 찾았음. 다시 말해서, 두 그룹이 같다 라는 귀무가설을 가장 크게
# 기각하는 백분위수를 찾았음.

# 그 결과, wind=3.7, humidity=29로 선정하게 되었음.
# wind 3.7이상은 강풍(1), 미만은 약풍(0)
# humidity 29이하는 건조(1), 미만은 습함(0)
# 그래서, 기후 위험도 = I(wind>=3.7) + I(humid<=29)로 설정
dat_indexed
dat_indexed2 %>% arrange(dmg_ind) %>% select(dmg_ind, ind, n)
data %>%
    group_by(Group, Value) %>%
    summarise(n=n())
dat_clim %>%
    select(-loc) %>%
    mutate(ind1 = case_when(wind <= 3.7 ~ 0,
                            wind > 3.7 ~ 1),
           ind2 = case_when(humid <= 29 ~ 1,
                            humid > 29 ~ 0),
           dmg_ind = case_when(dmg <= 1.4 ~ 0,
                               dmg > 1.4 ~ 1)) %>%
    mutate(ind = ind1+ind2) %>%
    select(-ind1, -ind2) %>%
    group_by(ind, dmg_ind) -> dat_indexed
dat_indexed %>%
    summarise(n = n(), .groups='keep') -> dat_indexed2

dat_indexed2

dmg_low <- c(rep(0, 178), rep(1, 184), rep(2, 45))
dmg_high <- c(rep(0, 9), rep(1, 24), rep(2, 13))
dmg_low_df <- data.frame(group = "low", value = dmg_low)
dmg_high_df <- data.frame(group = "high", value = dmg_high)
dmg_group <- rbind(dmg_low_df, dmg_high_df)
kruskal.test(value ~ group, data = dmg_group)
dmg_group
# low와 high는 명확히 다르다.

# ind에 따른 kw test
group_A <- c(rep(0, 178), rep(1, 9))
group_B <- c(rep(0, 184), rep(1, 24))
group_C <- c(rep(0, 45), rep(1, 13))
data_A <- data.frame(Group = "A", Value = group_A)
data_B <- data.frame(Group = "B", Value = group_B)
data_C <- data.frame(Group = "C", Value = group_C)
data <- rbind(data_A, data_B, data_C)
kruskal.test(Value ~ Group, data = data)
# 다르다.

head(dmg_group)
kruskal.test(value ~ group, data = dmg_group)
kruskal.test(Value ~ Group, data = data)
# => value별로 group 분포가 같다는 귀무가설을 기각.
# => group별로 value 분포가 같다는 귀무가설을 기각.
# 다시말해, 기후 위험지표로 피해량의 심각도를 구분하는게 유효하다.
# 

# 기후 위험지표를 적용한 모델링
# 여기부턴 climate_index적용fitting 참조.


# dmg ~ (T + S)Climate_index + error
# 왜 곱하기냐?
# 그냥 더하기로 하니까 적합이 잘 안됨.
# 그래서 그냥 곱하기 모델로 적용하지 않을까 생각했음.
# 우리는 "피해량"에 대해 모델링하고있음.
