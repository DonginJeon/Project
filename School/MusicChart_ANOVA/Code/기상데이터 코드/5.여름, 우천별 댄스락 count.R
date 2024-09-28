rm(list=ls())

#여름, 비O
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설3/여름, 비O')

dat1 <- read.csv("20200713.csv")
dat2 <- read.csv("20210719.csv")
dat3 <- read.csv("20220716.csv")
dat4 <- read.csv("20230829.csv")

dat_list <- list(dat1, dat2, dat3, dat4)

for (i in 1:4) {
  count <- sum(grepl("댄스|락", dat_list[[i]]$genre))
  assign(paste0("count_", i), count)
}


dat <- data.frame(times = integer(), rain = character(), summer = character(), 
                  value = integer(), stringsAsFactors = FALSE)
for (i in 1:4) {
  value <- get(paste0("count_", i))
  dat[i, ] <- c(i, 1, 1, value)
}

#여름, 비X
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설3/여름, 비X')

dat5 <- read.csv("20200824.csv")
dat6 <- read.csv("20210714.csv")
dat7 <- read.csv("20220728.csv")
dat8 <- read.csv("20230815.csv")

dat_list2 <- list(dat5, dat6, dat7, dat8)

for (i in 1:4) {
  count <- sum(grepl("댄스|락", dat_list2[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:4) {
  value <- get(paste0("count_", i))
  dat[i+4, ] <- c(i, 0, 1, value)
}

#여름X, 비O
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설3/여름X, 비O')

dat9 <- read.csv("20200903.csv")
dat10 <- read.csv("20210327.csv")
dat11 <- read.csv("20220905.csv")
dat12 <- read.csv("20230920.csv")

dat_list3 <- list(dat9, dat10, dat11, dat12)

for (i in 1:4) {
  count <- sum(grepl("댄스|락", dat_list3[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:4) {
  value <- get(paste0("count_", i))
  dat[i+8, ] <- c(i, 1, 0, value)
}

#여름X, 비X
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설3/여름X, 비X')

dat13 <- read.csv("20201205.csv")
dat14 <- read.csv("20210418.csv")
dat15 <- read.csv("20220529.csv")
dat16 <- read.csv("20230914.csv")

dat_list4 <- list(dat13, dat14, dat15, dat16)

for (i in 1:4) {
  count <- sum(grepl("댄스|락", dat_list4[[i]]$genre))
  assign(paste0("count_", i), count)
}

for (i in 1:4) {
  value <- get(paste0("count_", i))
  dat[i+12, ] <- c(i, 0, 0, value)
}

write.csv(dat, file = "summer_dance.csv", row.names = FALSE)
