rm(list=ls())

#2021 봄
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1-2/2021년')

dat1 <- read.csv("20210306.csv")
dat2 <- read.csv("20210403.csv")
dat3 <- read.csv("20210512.csv")
combined_dat <- rbind(dat1, dat2, dat3)

spring_2021 <- sum(grepl("발라드", combined_dat$genre))

#2021 여름
dat1 <- read.csv("20210617.csv")
dat2 <- read.csv("20210715.csv")
dat3 <- read.csv("20210805.csv")
combined_dat <- rbind(dat1, dat2, dat3)

summer_2021 <- sum(grepl("발라드", combined_dat$genre))

#2021 가을
dat1 <- read.csv("20210929.csv")
dat2 <- read.csv("20211019.csv")
dat3 <- read.csv("20211119.csv")
combined_dat <- rbind(dat1, dat2, dat3)

autumn_2021 <- sum(grepl("발라드", combined_dat$genre))

#2021 겨울
dat1 <- read.csv("20210130.csv")
dat2 <- read.csv("20210216.csv")
dat3 <- read.csv("20211220.csv")
combined_dat <- rbind(dat1, dat2, dat3)

winter_2021 <- sum(grepl("발라드", combined_dat$genre))



#2022 봄
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1-2/2022년')

dat1 <- read.csv("20200320.csv")
dat2 <- read.csv("20220409.csv")
dat3 <- read.csv("20220507.csv")
combined_dat <- rbind(dat1, dat2, dat3)

spring_2022 <- sum(grepl("발라드", combined_dat$genre))

#2022 여름
dat1 <- read.csv("20220626.csv")
dat2 <- read.csv("20220704.csv")
dat3 <- read.csv("20220827.csv")
combined_dat <- rbind(dat1, dat2, dat3)

summer_2022 <- sum(grepl("발라드", combined_dat$genre))

#2022 가을
dat1 <- read.csv("20220912.csv")
dat2 <- read.csv("20221001.csv")
dat3 <- read.csv("20221120.csv")
combined_dat <- rbind(dat1, dat2, dat3)

autumn_2022 <- sum(grepl("발라드", combined_dat$genre))

#2022 겨울
dat1 <- read.csv("20220122.csv")
dat2 <- read.csv("20220204.csv")
dat3 <- read.csv("20221217.csv")
combined_dat <- rbind(dat1, dat2, dat3)

winter_2022 <- sum(grepl("발라드", combined_dat$genre))




#2023 봄
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말/데이터모음/가설1-2/2023년')

dat1 <- read.csv("20230315.csv")
dat2 <- read.csv("20230427.csv")
dat3 <- read.csv("20230526.csv")
combined_dat <- rbind(dat1, dat2, dat3)

spring_2023 <- sum(grepl("발라드", combined_dat$genre))

#2023 여름
dat1 <- read.csv("20230617.csv")
dat2 <- read.csv("20230717.csv")
dat3 <- read.csv("20230803.csv")
combined_dat <- rbind(dat1, dat2, dat3)

summer_2023 <- sum(grepl("발라드", combined_dat$genre))

#2023 가을
dat1 <- read.csv("20230929.csv")
dat2 <- read.csv("20231026.csv")
dat3 <- read.csv("20231111.csv")
combined_dat <- rbind(dat1, dat2, dat3)

autumn_2023 <- sum(grepl("발라드", combined_dat$genre))

#2023 겨울
dat1 <- read.csv("20230117.csv")
dat2 <- read.csv("20230226.csv")
dat3 <- read.csv("20231215.csv")
combined_dat <- rbind(dat1, dat2, dat3)

winter_2023 <- sum(grepl("발라드", combined_dat$genre))


#데이터 프레임 생성
season <- factor(c('spring', 'summer', 'autumn', 'winter'))
block <- factor(c(2021, 2022, 2023))

dat <- expand.grid(block = block, season = season)

dat$value <- c(spring_2021, spring_2022, spring_2023,
               summer_2021, summer_2022, summer_2023,
               autumn_2021, autumn_2022, autumn_2023,
               winter_2021, winter_2022, winter_2023)
dat

write.csv(dat, file = "season_balad.csv", row.names = FALSE)
