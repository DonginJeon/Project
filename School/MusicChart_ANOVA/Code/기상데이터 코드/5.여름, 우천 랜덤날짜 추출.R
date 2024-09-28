rm(list=ls())

#경로 지정
setwd('C:/Users/senio/OneDrive/바탕 화면/기상청 데이터')

library(dplyr)
library(lubridate)

#코드 실행전 각 파일의 이름을 20XX_data.csv로 변경하기
data_2018 <- read.csv("2018_data.csv", fileEncoding = "EUC-KR")
data_2019 <- read.csv("2019_data.csv", fileEncoding = "EUC-KR")
data_2020 <- read.csv("2020_data.csv", fileEncoding = "EUC-KR")
data_2021 <- read.csv("2021_data.csv", fileEncoding = "EUC-KR")
data_2022 <- read.csv("2022_data.csv", fileEncoding = "EUC-KR")
data_2023 <- read.csv("2023_data.csv", fileEncoding = "EUC-KR")

#각 년도별 데이터들 합치기
combined_data <- bind_rows(data_2018, data_2019, data_2020,
                           data_2021, data_2022, data_2023)

#필요한 열만 남기고 삭제
data <- combined_data %>%
  select(date = "일시", daily_precip = "일강수량.mm.", snow = "일.최심적설.cm.")



#여름, 비X
filtered_data1 <- data %>%
  filter(month(as.Date(date)) %in% 6:8, # 'date'가 6월, 7월, 8월인 행 필터링
         is.na(daily_precip), # 'daily_precip'가 NA인 행 필터링
         is.na(snow)) %>% # 'snow'가 NA인 행 필터링
  mutate(year = year(as.Date(date))) # 'date'로부터 년도 추출

random_dates1 <- filtered_data1 %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates1)



#여름, 비O
filtered_data2 <- data %>%
  filter(month(as.Date(date)) %in% 6:8, # 'date'가 6월, 7월, 8월인 행 필터링
         daily_precip >= 20, # 'daily_precip'가 20이상
         is.na(snow)) %>% # 'snow'가 NA인 행 필터링
  mutate(year = year(as.Date(date))) # 'date'로부터 년도 추출

random_dates2 <- filtered_data2 %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates2)



#여름X, 비O
filtered_data3 <- data %>%
  filter(!month(as.Date(date)) %in% 6:8, # 'date'가 6월, 7월, 8월인 행 필터링
         daily_precip >= 20, # 'daily_precip'가 20이상
         is.na(snow)) %>% # 'snow'가 NA인 행 필터링
  mutate(year = year(as.Date(date))) # 'date'로부터 년도 추출

random_dates3 <- filtered_data3 %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates3)

#여름X, 비X
filtered_data4 <- data %>%
  filter(!month(as.Date(date)) %in% 6:8, # 'date'가 6월, 7월, 8월인 행 필터링
         is.na(daily_precip), # 'daily_precip'가 NA인 행 필터링
         is.na(snow)) %>% # 'snow'가 NA인 행 필터링
  mutate(year = year(as.Date(date))) # 'date'로부터 년도 추출

random_dates4 <- filtered_data4 %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates4)
