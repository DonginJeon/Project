rm(list=ls())

#강수, 0~10
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설2/우천/0~10')

dat1 <- read.csv("20180406.csv")
dat2 <- read.csv("20190410.csv")
dat3 <- read.csv("20200212.csv")
dat4 <- read.csv("20211130.csv")
dat5 <- read.csv("20221212.csv")
dat6 <- read.csv("20231211.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

dat <- data.frame(times = integer(), weather = character(), temp = character(), 
                  value = integer(), stringsAsFactors = FALSE)

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i, ] <- c(i, '강수', '0~10', value)
}

#강수, 10~20
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설2/우천/10~20')

dat1 <- read.csv("20180522.csv")
dat2 <- read.csv("20190320.csv")
dat3 <- read.csv("20200519.csv")
dat4 <- read.csv("20210430.csv")
dat5 <- read.csv("20221002.csv")
dat6 <- read.csv("20231014.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+6, ] <- c(i, '강수', '10~20', value)
}

#강수, 20~30
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설2/우천/20~30')

dat1 <- read.csv("20180821.csv")
dat2 <- read.csv("20190716.csv")
dat3 <- read.csv("20200629.csv")
dat4 <- read.csv("20210703.csv")
dat5 <- read.csv("20220721.csv")
dat6 <- read.csv("20230823.csv")

dat_list <- list(dat1, dat2, dat3, dat4, dat5, dat6)

for (i in 1:6) {
  count <- sum(grepl("발라드", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:6) {
  value <- get(paste0("count_", i))
  dat[i+12, ] <- c(i, '강수', '20~30', value)
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
  dat[i+18, ] <- c(i, '맑음', '0~10', value)
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
  dat[i+24, ] <- c(i, '맑음', '10~20', value)
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
  dat[i+30, ] <- c(i, '맑음', '20~30', value)
}



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
  dat[i+36, ] <- c(i, '흐림', '0~10', value)
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
  dat[i+42, ] <- c(i, '흐림', '10~20', value)
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
  dat[i+48, ] <- c(i, '흐림', '20~30', value)
}

dat
write.csv(dat, file = "test.csv", row.names = FALSE)
