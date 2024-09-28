rm(list=ls())

#경로 지정
setwd('C:/Users/senio/OneDrive/바탕 화면/기상청 데이터')

library(dplyr)

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
  select(date = "일시", avg_temp = "평균기온..C.", daily_precip = "일강수량.mm.", avg_cloud = "평균.전운량.1.10.")

#write.csv(data, "weatherdata_2018-2023.csv", row.names = FALSE)

library(lubridate)

#맑음, -10°C ~ 0°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= -10, avg_temp < 0, is.na(daily_precip), avg_cloud >= 0, avg_cloud < 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates1 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates1)

#맑음, 0°C ~ 10°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 0, avg_temp < 10, is.na(daily_precip), avg_cloud >= 0, avg_cloud < 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates2 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates2)

#맑음, 10°C ~ 20°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 10, avg_temp < 20, is.na(daily_precip), avg_cloud >= 0, avg_cloud < 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates3 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates3)

#맑음, 20°C ~ 30°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 20, avg_temp < 30, is.na(daily_precip), avg_cloud >= 0, avg_cloud < 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates4 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates4)

#흐림, -10°C ~ 0°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= -10, avg_temp < 0, is.na(daily_precip), avg_cloud >= 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates5 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates5)

#흐림, 0°C ~ 10°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 0, avg_temp < 10, is.na(daily_precip), avg_cloud >= 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates6 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates6)

#흐림, 10°C ~ 20°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 10, avg_temp < 20, is.na(daily_precip), avg_cloud >= 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates7 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates7)

#흐림, 20°C ~ 30°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 20, avg_temp < 30, is.na(daily_precip), avg_cloud >= 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates8 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates8)

#강수, -10°C ~ 0°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= -10, avg_temp < 0, daily_precip >= 0.1, avg_cloud >= 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates9 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates9)

#강수, 0°C ~ 10°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 0, avg_temp < 10, daily_precip >= 0.1, avg_cloud >= 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates10 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates10)

#강수, 10°C ~ 20°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 10, avg_temp < 20, daily_precip >= 0.1, avg_cloud >= 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates11 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates11)

#강수, 20°C ~ 30°C인 날짜 각 년도에서 하나씩 추출
filtered_data <- data %>%
  filter(avg_temp >= 20, avg_temp < 30, daily_precip >= 0.1, avg_cloud >= 5.5)

filtered_data <- filtered_data %>%
  mutate(year = year(date))

random_dates12 <- filtered_data %>%
  group_by(year) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  select(date)

print(random_dates12)