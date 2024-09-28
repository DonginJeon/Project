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
  select(date = "일시", daily_precip = "일강수량.mm.", snow = "일.최심적설.cm.")

#비 오는 날 6일 추출
rain_data <- data %>%
  filter(daily_precip >= 20, is.na(snow))

n <- nrow(rain_data)

random_indices <- sample(n, 6)

random_rows <- rain_data[random_indices, ]

print(random_rows)

#비 안오는 날 6일 추출
not_rain_data <- data %>%
  filter(is.na(daily_precip), is.na(snow))

n <- nrow(not_rain_data)

random_indices <- sample(n, 6)

random_rows <- not_rain_data[random_indices, ]

print(random_rows)
