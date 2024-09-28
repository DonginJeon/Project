rm(list=ls())

#비O
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설2/비O')

dat1 <- read.csv("20180702_title.csv")
rain_1 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat1$Title, ignore.case = TRUE))

dat2 <- read.csv("20200624_title.csv")
rain_2 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat2$Title, ignore.case = TRUE))

dat3 <- read.csv("20200810_title.csv")
rain_3 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat3$Title, ignore.case = TRUE))

dat4 <- read.csv("20200903_title.csv")
rain_4 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat4$Title, ignore.case = TRUE))

dat5 <- read.csv("20210703_title.csv")
rain_5 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat5$Title, ignore.case = TRUE))

dat6 <- read.csv("20220809_title.csv")
rain_6 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat6$Title, ignore.case = TRUE))

dat <- data.frame(rain = character(), value = integer(), stringsAsFactors = FALSE)

for (i in 1:6) {
  rain_value <- get(paste0("rain_", i))
  dat[i, ] <- c('1', rain_value)
}

#비X
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설2/비X')

dat1 <- read.csv("20181012_title.csv")
not_rain_1 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat1$Title, ignore.case = TRUE))

dat2 <- read.csv("20191106_title.csv")
not_rain_2 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat2$Title, ignore.case = TRUE))

dat3 <- read.csv("20191116_title.csv")
not_rain_3 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat3$Title, ignore.case = TRUE))

dat4 <- read.csv("20191206_title.csv")
not_rain_4 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat4$Title, ignore.case = TRUE))

dat5 <- read.csv("20221021_title.csv")
not_rain_5 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat5$Title, ignore.case = TRUE))

dat6 <- read.csv("20231015_title.csv")
not_rain_6 <- sum(grepl("비|빗|우산|소나기|rain|Rain", dat6$Title, ignore.case = TRUE))

for (i in 1:6) {
  rain_value <- get(paste0("not_rain_", i))
  dat[i+6, ] <- c(0, rain_value)
}

dat

write.csv(dat, file = "rain_count.csv", row.names = FALSE)
