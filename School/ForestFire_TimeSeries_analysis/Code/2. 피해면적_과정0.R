# 피해 면적과 관련한 TS 분석

# 피해면적 단위는 뭐지?
# https://www.forest.go.kr/kfsweb/kfi/kfs/frfr/selectFrfrStats.do?mn=NKFS_02_02_01_05
str(dat_raw$피해면적_합계)
dat_raw %>%
    group_by(발생일시_년) %>%
    summarise(sumOfDmgArea = sum(피해면적_합계))
# 음 헥타르구나.


# 1. 피해 면적과 날짜를 비교하여, 어느 시점의 산불이 위협적일까?
tibble(dat_1) %>% View()
dat_1$피해면적_합계 <- as.numeric(dat_1$피해면적_합계)
t_base <- dat_1$발생일시 ; Z_t <- dat_1$피해면적_합계
plot(Z_t~t_base) # 이상치때문에 제대로 안보임..
t_under_0.95 <- dat_1$발생일시[under_0.95]
Z_t_under_0.95 <- dat_1$피해면적_합계[under_0.95]
plot(Z_t_under_0.95~t_under_0.95) # 뭐야.. 안보임
# 그 와중에도 뭔가 seasonality가 존재하는듯? 아닌가?
# seasonality를 확인하기 위해, tsplot으로 그려야겠음.
# t_under_0.95_ts <- ts(t_under_0.95, )..
# ts를 일 단위로 맞춰야하겠다 싶음. 초 단위로 ts가 너무 거시기함.

# ts_temp_eda에서 그대로 가져오고, 조금 변형.
date1 <- apply(dat_raw, 1, function(x){
    paste(x[1],x[2],x[3], sep='-')
})
head(date1) ; str(date1) # chr structure.
date1 <- ymd(date1)
head(date1) ; str(date1) # Convert chr to date
min(date1) ; max(date1)
dat_ymd_dmgArea <- tibble(
    fireDate = date1,
    dmgArea = dat_1$피해면적_합계
)
dat_ymd_dmgArea
ggplot(dat_ymd_dmgArea, aes(x=fireDate, y=dmgArea)) +
    geom_line()
# 뭐지? barplot처럼 나오는데. 이상치때문에 선 연결한게 안보이는건가
# 이상치 제거한 상태로 사용해보자.
dat_ymd_dmgArea %>%
    filter(dmgArea <= 2) %>% ggplot() +
    geom_line(aes(x=fireDate, y=dmgArea))
# 음... 더 보기 안좋아졌네 1년치만 볼까
dat_ymd_dmgArea %>%
    filter(dmgArea <= 2) %>% 
    filter(fireDate < date("2014-12-31")) %>% ggplot() +
    geom_line(aes(x=fireDate, y=dmgArea))
# 왜 보기 안좋은지 알았다. 특정 구간에 하도 몰려있으니까.
# 그리고, 하루에 여러건 발생하는것도 있으니까.
# 하루에 여러건 발생한 경우 처리를 위해, 총합과 평균 두가지로 고려하자
dat_ymd_dmgArea$fireDate %>% unique() %>% length() # 총 화재 발생 일수가 며칠이지?
dat_ymd_dmgArea %>%
    group_by(fireDate) %>% # group_by하고 group 갯수랑 일치하네. 오류 발생 안했네.
    mutate(dmgAreaSum = sum(dmgArea)) %>%
    mutate(dmgAreaMean = mean(dmgArea)) -> dat_ymd_dmgArea
dat_ymd_dmgArea
dat_ymd_dmgArea %>%
    select(fireDate, dmgAreaSum) %>%
    filter(dmgAreaSum <= 100) %>% # 100은 그냥 임의로 설정한거
    unique() %>% ggplot() +
    geom_line(aes(x=fireDate, y=dmgAreaSum))
# 음.. sum으로 하니까 filter를 어디로 잡아야 할지 애매하네.
# mean으로 그리고 filter를 2.0으로 잡아서 plotting해보자.
dat_ymd_dmgArea %>%
    select(fireDate, dmgAreaMean) %>%
    filter(dmgAreaMean <= 2) %>% 
    filter(fireDate < date("2014-12-31")) %>%
    unique() %>% ggplot() +
    geom_line(aes(x=fireDate, y=dmgAreaMean)) +
    # 추후에 추가한 플롯
    geom_vline(xintercept = c(seq.Date(from=date("2013-03-01"),
                                     to=date("2013-05-01"),
                                     by="month"),
                              seq.Date(from=date("2014-03-01"),
                                       to=date("2014-05-01"),
                                       by="month")),
               linetype="dashed", color="red", alpha=0.5)
# 명확하게, 피해면적은 빈도의 그 시즈널리티를 따르는 것으로 보인다.
# 피해면적을 평균값으로 처리했기 때문에 그날 많이 발생했는지는
# 중요하지 않다. 
# 다시 보니까... 흠..
# 그래도 기존 시즈널리티 경향을 따라가긴 함.

# 모델을 고려해보자
# 피해면적 = 트렌드 + 월별 시즈널리티
# 이 모델은, 피해 면적이 트렌드와 시즈널리티로 설명할 수 있다는 모델
# 부족한점은, 역시 이상치 처리 문제겠지.

# ( keep goin at part 2)