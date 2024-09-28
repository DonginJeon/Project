datadir <- "C:/Users/p5682/Documents/카카오톡 받은 파일/sanbul.xls"

##### Data preprocess
## Load
dat_raw <- readxl::read_excel(datadir, skip=1)

## View, glimpse
View(dat_raw)

## Mutate : time data
date1 <- apply(dat_raw, 1, function(x){
    paste(x[1],x[2],x[3],x[4], sep='-')
})
date2 <- apply(dat_raw, 1, function(x){
    paste(x[6],x[7],x[8],x[9], sep='-')
})
date1 <- ymd_hm(date1)
date2 <- ymd_hm(date2)
dat_1 <- cbind('발생일시'=date1, dat_raw[,-c(1:4)])
dat_1 <- cbind(dat_1[,1:2], '진화일시'=date2, dat_1[,-c(1:6)])
View(dat_1)
## Null, NA check
apply(dat_raw, 2, function(x){any(is.na(x))})
# 몇개의 열이 na가 발견되었다.
# 발생장소_관서, 발생장소_시군구, 
# 발생장소_읍면, 발생장소_동리, 발생원인_구분
# 발생장소에서는 시도의 경우 모두 존재한다.
# 도 이하 발생장소로 구분할 수 없을경우, NA 처리하는 모양이다.
# 발생원인 또한 구분하기 애매하면 NA처리하는 것 같다.
dat_raw_na <- zoo::na.fill(dat_raw, fill='none')
apply(dat_raw_na, 2, function(x){any(is.na(x))})
##################################################
##### EDA


##### 1. 화재 발생에 대한 자료확인
View(dat_raw)
date3 <- apply(dat_raw, 1, function(x){
    paste(x[1],x[2],x[3], sep='-')
})
date3 <- as.Date(date3)
min(date3) ; max(date3)
{   # 화재가 안난 날도 있어서, 그거 처리해주기 위함 임시 date 생성
    start_date <- as.Date(min(date1))
    end_date <- as.Date(max(date1))
    date_range <- seq(from = start_date, to = end_date, by = "days")
}
temp1 <- table(c(date3, date_range))
head(temp1)
temp1 <- temp1-1
head(temp1)
t <- ts(temp1, frequency = 365, start=c(2013,1,8))

ts.plot(t)
## 1년동안의 주기는 존재하는듯.
## 추세는 살짝 감소하는 추세?


View(dat_raw)
date4 <- as.Date(dat_1$발생일시)
head(date4)
monthly_counts <- table(format(date4, "%Y-%m"))
t2 <- ts(monthly_counts, frequency = 12, start=c(2013,1))
t2
head(monthly_counts)
ts.plot(t2)
par(mfrow=c(1,2))
ts.plot(t2) ; ts.plot(t)
# 일별이냐 월별이냐가 다를 뿐이지, 생긴 추세는 같음. 당연하게도
# 좀 더 보기 편한 월별 자료를 보겠음
par(mfrow=c(1,1))
ts.plot(t2)
## 2015 peak를 찍고 감소하는 트렌드가 있는듯
## 주기성이 존재하는듯 아마도 월별?
## 

## 분석을 한다면 뭘 할 수 있을까?
# 일단, '시계열'분석이므로 시간을 변수로 둬야함.
# 현재 자료에서 시간은 발생시간, 진화시간 두개임
# 시계열 분석에서 중점은 시간에 따른 값의 변화를 설명하는 것

# 체크해볼만한 내용
# 1. 지역별로 자주 화재가 발생하는 time에 차이가 있는가?
# -> 산이 많은 지역은 관광객이 많이오는 시기에 더 화재가 발생할수도?
# -> 시도에 대해서만 분류가 na없이 되어있으므로, 시도만 기준삼아보자
# 2. 우리나라 대처능력이 좋아지고 있는가?
# -> 피해면적이 시간에 따라 줄어드는 trend가 있는지 확인
# -> 혹은, 사건사고의 경우 벌어지고 난 후 수습과정에서 동일한
#    사고를 막는데 집중하는 경향이 있으므로, 평활추정을 적용할 수도 있을 것 같음
plot(dat_1$피해면적_합계~dat_1$발생일시)
plot(dat_1$피해면적_합계~dat_1$발생일시, ylim=c(0, 5000))
plot(dat_1$피해면적_합계~dat_1$발생일시, ylim=c(0, 1000))
# 오히려 피해면적 큰건 늘어나는 것 같기도?
# 하지만, 큰 산불의 경우 outlier로 볼 수도 있음.
fire_duration <- dat_1$진화일시-dat_1$발생일시
as.numeric(fire_duration)
plot(((as.numeric(dat_1$피해면적_합계)^(1/3))
      /as.numeric(fire_duration))~dat_1$발생일시,
     ylab="피해면적^1/3",
     xlab="발생 일시")
# 면적은 길이의 3power이므로, 단순히 3만큼 나눠줘봤음.
# 뭐 딱히 시간에 따라 피해량이 줄어든 것 같진 않음.


## 분석 목적에 따라서 지역별 시간에따른 빈도변화,
## 발생 원인에 따른 빈도변화, 피해량변화, 등등을
## 고려할 수 있겠다 싶음.
times <- dat_1$진화일시-dat_1$발생일시
head(times)
length(times)
nrow(dat_raw)
is.na(times)
days <- dat_1$발생일시
df1 <- tibble(days = days,
              exhaust_time = as.numeric(times))
df1
ggplot(df1) +
    geom_point(aes(x = days, y = ifelse((exhaust_time>0)*(exhaust_time<30000), abs(exhaust_time), 0)))
hist(as.numeric(times))
min(times)
sort(times)
which.min(times)
days[778]
dat_1[778,]
dat_1[778,3] - dat_1[778,1]
# Create Data
length(unique(as.factor(dat_1$발생원인_세부원인인)))
table_fire <- as.data.frame(table(dat_1$발생원인_기타))
str(table_fire)
table_fire$
ggplot(table_fire, aes(x="", y=Freq, fill=Var1)) +
    geom_bar(stat='identity', width=1) +
    coord_polar("y", start=0)
table(dat_1$발생장소_시도)
