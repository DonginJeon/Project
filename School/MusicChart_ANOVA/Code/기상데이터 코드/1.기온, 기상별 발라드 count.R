rm(list=ls())

#강수, -10~0
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/강수/-10~0')

dat1 <- read.csv("20180130.csv", fileEncoding = "EUC-KR")
dat2 <- read.csv("20191207.csv", fileEncoding = "EUC-KR")
dat3 <- read.csv("20200101.csv", fileEncoding = "UTF-8")
dat4 <- read.csv("20210112.csv", fileEncoding = "EUC-KR")
dat5 <- read.csv("20220201.csv", fileEncoding = "UTF-8")
dat6 <- read.csv("20230126.csv", fileEncoding = "UTF-8")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

dat <- data.frame(times = integer(), weather = character(), temp = character(), 
                  value = integer(), stringsAsFactors = FALSE)
for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i, ] <- c(i, '강수', '-10~0', value)
}

#강수, 0~10
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/강수/0~10')

dat1 <- read.csv("20181121.csv")
dat2 <- read.csv("20191211.csv")
dat3 <- read.csv("20200106.csv")
dat4 <- read.csv("20210126.csv")
dat5 <- read.csv("20221213.csv")
dat6 <- read.csv("20231214.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+6, ] <- c(i, '강수', '0~10', value)
}

#강수, 10~20
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/강수/10~20')

dat1 <- read.csv("20180315.csv")
dat2 <- read.csv("20190922.csv")
dat3 <- read.csv("20201118.csv")
dat4 <- read.csv("20210404.csv")
dat5 <- read.csv("20220429.csv")
dat6 <- read.csv("20230505.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+12, ] <- c(i, '강수', '10~20', value)
}

#강수, 20~30
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/강수/20~30')

dat1 <- read.csv("20180915.csv")
dat2 <- read.csv("20190730.csv")
dat3 <- read.csv("20200805.csv")
dat4 <- read.csv("20210929.csv")
dat5 <- read.csv("20220814.csv")
dat6 <- read.csv("20230626.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+18, ] <- c(i, '강수', '20~30', value)
}





#맑음, -10~0
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/맑음/-10~0')


dat1 <- read.csv("20181224.csv")
dat2 <- read.csv("20190204.csv")
dat3 <- read.csv("20200112.csv")
dat4 <- read.csv("20210218.csv")
dat5 <- read.csv("20220206.csv")
dat6 <- read.csv("20230101.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+24, ] <- c(i, '맑음', '-10~0', value)
}

#맑음, 0~10
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/맑음/0~10')

dat1 <- read.csv("20181119.csv")
dat2 <- read.csv("20191224.csv")
dat3 <- read.csv("20200411.csv")
dat4 <- read.csv("20210309.csv")
dat5 <- read.csv("20221018.csv")
dat6 <- read.csv("20230304.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+30, ] <- c(i, '맑음', '0~10', value)
}

#맑음, 10~20
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/맑음/10~20')

dat1 <- read.csv("20180329.csv")
dat2 <- read.csv("20190504.csv")
dat3 <- read.csv("20201113.csv")
dat4 <- read.csv("20210524.csv")
dat5 <- read.csv("20221119.csv")
dat6 <- read.csv("20231024.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+36, ] <- c(i, '맑음', '10~20', value)
}

#맑음, 20~30
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/맑음/20~30')

dat1 <- read.csv("20180707.csv")
dat2 <- read.csv("20190916.csv")
dat3 <- read.csv("20200708.csv")
dat4 <- read.csv("20211002.csv")
dat5 <- read.csv("20220601.csv")
dat6 <- read.csv("20230523.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+42, ] <- c(i, '맑음', '20~30', value)
}




#흐림, -10~0
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/흐림/-10~0')

dat1 <- read.csv("20180218.csv")
dat2 <- read.csv("20190104.csv")
dat3 <- read.csv("20190104.csv")
dat4 <- read.csv("20210111.csv")
dat5 <- read.csv("20221204.csv")
dat6 <- read.csv("20231218.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+48, ] <- c(i, '흐림', '-10~0', value)
}
dat[51, ] <- c(3, '흐림', '-10~0', NA)

#흐림, 0~10
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/흐림/0~10')

dat1 <- read.csv("20180114.csv")
dat2 <- read.csv("20190130.csv")
dat3 <- read.csv("20201124.csv")
dat4 <- read.csv("20211211.csv")
dat5 <- read.csv("20220323.csv")
dat6 <- read.csv("20230213.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+54, ] <- c(i, '흐림', '0~10', value)
}

#흐림, 10~20
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/흐림/10~20')

dat1 <- read.csv("20180413.csv")
dat2 <- read.csv("20191023.csv")
dat3 <- read.csv("20201014.csv")
dat4 <- read.csv("20211119.csv")
dat5 <- read.csv("20220513.csv")
dat6 <- read.csv("20230322.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+60, ] <- c(i, '흐림', '10~20', value)
}

#흐림, 20~30
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1/흐림/20~30')

dat1 <- read.csv("20180617.csv")
dat2 <- read.csv("20191001.csv")
dat3 <- read.csv("20200615.csv")
dat4 <- read.csv("20210828.csv")
dat5 <- read.csv("20220625.csv")
dat6 <- read.csv("20230831.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+66, ] <- c(i, '흐림', '20~30', value)
}

dat
write.csv(dat, file = "weather_balad.csv", row.names = FALSE)
