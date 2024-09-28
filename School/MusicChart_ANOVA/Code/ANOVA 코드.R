rm(list=ls())
library(readxl)
library(MASS)
#############################################################
##### 히스토그램, Q-Q plot, ANOVA #####

#####가설1(기온, 기상별 발라드)#####
setwd('C:/Users/senio/OneDrive/바탕 화면/실험계획법 기말')
data1 <- read_excel('final_data.xlsx', sheet=1)
data1[9,]$value <- "24.8" #해당 셀 내에서 평균으로 대체
data1$value <- as.numeric(data1$value)
data1$weather <- as.factor(data1$weather)
data1$temp <- as.factor(data1$temp)
final_data1 <- data1

#boxcox 변수변환
boxcox_result <- boxcox(lm(final_data1$value ~ 1), lambda = seq(-2, 2, by = 0.1))
lambda <- boxcox_result$x[which.max(boxcox_result$y)]; lambda
transformed_data <- if (lambda == 0) log(final_data1$value) else (final_data1$value^lambda - 1) / lambda
final_data1$value <- transformed_data #변환된 데이터 value값으로 추가

par(mfrow = c(2, 2))
#원본 그래프
hist(data1$value, breaks = 10, main = "Count of balad", xlab = "Value")
qqnorm(data1$value, main = "QQ plot of balad")
qqline(data1$value)
#변환된 그래프
hist(final_data1$value, breaks = 10, main = "transformed version", xlab = "Value")
qqnorm(final_data1$value, main = "transformed version") 
qqline(final_data1$value) 

#ANOVA
fit1 <- aov(value ~ weather * temp,data = final_data1) #변환된 데이터로 아노바
anova(fit1)


#####가설2(기온, 우천별 발라드)#####
data2 <- read_excel('final_data.xlsx', sheet=2)#데이터 불러들이기
final_data2 <- data2

#boxcox 변수변환
boxcox_result <- boxcox(lm(final_data2$value ~ 1), lambda = seq(-2, 2, by = 0.1))
lambda <- boxcox_result$x[which.max(boxcox_result$y)]; lambda
transformed_data <- if (lambda == 0) log(final_data2$value) else (final_data2$value^lambda - 1) / lambda
final_data2$value <- transformed_data #변환된 데이터 value값으로 추가

final_data2$weather <- as.factor(final_data2$weather)
final_data2$temp <- as.factor(final_data2$temp)

par(mfrow = c(2, 2))
#원본 그래프
hist(data2$value, breaks = 10, main = "Count of balad", xlab = "Value")
qqnorm(data2$value, main = "QQ plot of balad")
qqline(data2$value)
#변환된 그래프
hist(final_data2$value, breaks = 10, main = "transformed version", xlab = "Value")
qqnorm(final_data2$value, main = "transformed version") 
qqline(final_data2$value) 

#ANOVA
fit2 <- aov(value ~ weather * temp,data = final_data2) #변환된 데이터로 아노바
anova(fit2)


#####가설3(계절별 발라드)#####
data3 <- read_excel('final_data.xlsx',sheet = 3)
data3$block <- as.factor(data3$block)
final_data3 <- data3

par(mfrow = c(1, 2))
#원본 그래프
hist(final_data3$value, breaks = 10, main = "Count of balad", xlab = "Value")
qqnorm(final_data3$value, main = "QQ plot of balad")
qqline(final_data3$value)

#ANOVA
fit3 <- aov(value ~ season + block,data = final_data3) 
anova(fit3)


#####가설4(우천별 비 관련 제목)#####
data4 <- read_excel('final_data.xlsx',sheet = 4)
final_data4 <- data4

boxcox_result <- boxcox(lm(final_data4$value ~ 1), lambda = seq(-2, 2, by = 0.1))
lambda <- boxcox_result$x[which.max(boxcox_result$y)]; lambda
transformed_data <- if (lambda == 0) log(final_data4$value) else (final_data4$value^lambda - 1) / lambda
final_data4$value <- transformed_data #변환된 데이터 value값으로 할당


par(mfrow = c(2, 2))
#원본 그래프
hist(data4$value, breaks = 10, main = "Count of 'Rain' title", xlab = "Value")
qqnorm(data4$value, main = "QQ plot of 'Rain' title")
qqline(data4$value)
#변환된 그래프
hist(final_data4$value, breaks = 10, main = "transformed version", xlab = "Value")
qqnorm(final_data4$value, main = "transformed version") 
qqline(final_data4$value) 

fit4 <- aov(value ~ rain,data = final_data4) #아노바
anova(fit4)


#####가설5(계절, 우천별 댄스락)#####
data5 <- read_excel('final_data.xlsx',sheet = 5)
data5$rain <- as.factor(data5$rain)#factor 처리
data5$summer <- as.factor(data5$summer)# factor 처리
final_data5 <- data5

boxcox_result <- boxcox(lm(final_data5$value ~ 1), lambda = seq(-2, 2, by = 0.1))
lambda <- boxcox_result$x[which.max(boxcox_result$y)]; lambda
transformed_data <- if (lambda == 0) log(final_data5$value) else (final_data5$value^lambda - 1) / lambda
final_data5$value <- transformed_data #변환된 데이터 value값으로 할당

par(mfrow = c(2, 2))
#원본 그래프
hist(data5$value, breaks = 10, main = "Count of dance&rock", xlab = "Value")
qqnorm(data5$value, main = "QQ plot of dance&rock")
qqline(data5$value)
#변환된 그래프
hist(final_data5$value, breaks = 10, main = "transformed version", xlab = "Value")
qqnorm(final_data5$value, main = "transformed version") 
qqline(final_data5$value) 

fit5 <- aov(value ~  rain*summer, data = final_data5)#변환된 데이터 아노바
anova(fit5)


#############################################################
##### 잔차분석 #####

#####가설1(기온, 기상별 발라드)#####
a_fit1 <- aov(value ~ weather * temp,data = data1)
fit1 <- aov(value ~ weather * temp,data = final_data1)

par(mfrow = c(2, 2))
plot(a_fit1$fitted.values,a_fit1$residuals,pch = 16,main = 'Hypothesis 1',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(a_fit1$residuals,pch = 16,main = 'Original data residual')
qqline(a_fit1$residuals,col = 'red',lwd = 2)

plot(fit1$fitted.values,fit1$residuals,pch = 16,main = 'transformed version',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(fit1$residuals, pch = 16,main = 'transformed data residual')
qqline(fit1$residuals,col = 'red',lwd = 2)


#####가설2(기온, 우천별 발라드)#####
a_fit2 <- aov(value ~ weather * temp,data = data2)
fit2 <- aov(value ~ weather * temp,data = final_data2)

par(mfrow = c(2, 2))
plot(a_fit2$fitted.values,a_fit2$residuals,pch = 16,main = 'Hypothesis 2',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(a_fit2$residuals,pch = 16,main = 'Original data residual')
qqline(a_fit2$residuals,col = 'red',lwd = 2)

plot(fit2$fitted.values,fit2$residuals,pch = 16,main = 'transformed version',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(fit2$residuals, pch = 16,main = 'transformed data residual')
qqline(fit2$residuals,col = 'red',lwd = 2)


#####가설3(계절별 발라드)#####
fit3 <- aov(value ~ season + block,data = final_data3) 

par(mfrow = c(1, 2))
plot(fit3$fitted.values,fit3$residuals,pch = 16,main = 'Hypothesis 3',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(fit3$residuals,pch = 16,main = 'Original data residual')
qqline(fit3$residuals,col = 'red',lwd = 2)


#####가설4(우천별 비 관련 제목)#####
a_fit4 <- aov(value ~ rain,data = data4)
fit4 <- aov(value ~ rain,data = final_data4) 

par(mfrow = c(2, 2))
plot(a_fit4$fitted.values,a_fit4$residuals,pch = 16,main = 'Hypothesis 4',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(a_fit4$residuals,pch = 16,main = 'Original data residual')
qqline(a_fit4$residuals,col = 'red',lwd = 2)

plot(fit4$fitted.values,fit4$residuals,pch = 16,main = 'transformed version',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(fit4$residuals, pch = 16,main = 'transformed data residual')
qqline(fit4$residuals,col = 'red',lwd = 2)


#####가설5(계절, 우천별 댄스락)#####
a_fit5 <- aov(value ~  rain*summer, data = data5)
fit5 <- aov(value ~  rain*summer, data = final_data5)

par(mfrow = c(2, 2))
plot(a_fit5$fitted.values,a_fit5$residuals,pch = 16,main = 'Hypothesis 5',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(a_fit5$residuals,pch = 16,main = 'Original data residual')
qqline(a_fit5$residuals,col = 'red',lwd = 2)

plot(fit5$fitted.values,fit5$residuals,pch = 16,main = 'transformed version',xlab = 'Fitted value',ylab = 'Residual')
abline(h = 0, col = 'red')
qqnorm(fit5$residuals, pch = 16,main = 'transformed data residual')
qqline(fit5$residuals,col = 'red',lwd = 2)


#############################################################
##### main effect, interaction plot #####

#####가설1(기온, 기상별 발라드)#####
fit1 <- aov(value ~ weather * temp,data = final_data1) 

par(mfrow = c(1,1))
#main effect plot
main_effect_weather <- tapply(final_data1$value,final_data1$weather,mean)
plot(main_effect_weather,type = 'b',ylab = 'Value',xlab = 'Weather',xaxt = 'n')
axis(1,at = c(1,2,3),labels = c('강수','맑음','흐림'))

main_effect_temp <- tapply(final_data1$value,final_data1$temp,mean)
plot(main_effect_temp,type = 'b',ylab = 'Value',xlab = 'Temperature',xaxt = 'n')
axis(1,at = c(1,2,3,4),labels = c('-10°C~0°C ','0°C~10°C','10°C~20°C','20°C~30°C'))

#interaction plot
interaction.plot(final_data1$weather,final_data1$temp,response = final_data1$value, xlab = 'Weather',ylab = 'Value', main = 'Interaction between weather & temperature',type = 'o',legend = F,col = c(1,2,3,4))
legend('topright',legend = c('-10°C~0°C','0°C~10°C','10°C~20°C','20°C~30°C'),cex = 0.5,lty = 4:1,col = c(1,2,3,4))



#####가설2(기온, 우천별 발라드)#####
fit2 <- aov(value ~ weather * temp,data = final_data2) 

par(mfrow = c(1,1))
#main effect plot
main_effect_weather <- tapply(final_data2$value,final_data2$weather,mean)
plot(main_effect_weather,type = 'b',ylab = 'Value',xlab = 'Weather',xaxt = 'n')
axis(1,at = c(1,2,3),labels = c('비','맑음','흐림'))

main_effect_temp <- tapply(final_data2$value,final_data2$temp,mean)
plot(main_effect_temp,type = 'b',ylab = 'Value',xlab = 'Temperature',xaxt = 'n')
axis(1,at = c(1,2,3),labels = c('0°C~10°C','10°C~20°C','20°C~30°C'))

#interaction plot
interaction.plot(final_data2$weather,final_data2$temp,response = final_data2$value, xlab = 'Weather',ylab = 'Value', main = 'Interaction between weather & temperature',type = 'o',legend = F,col = c(1,2,3,4))
legend('topright',legend = c('0°C~10°C','10°C~20°C','20°C~30°C'),cex = 0.5,lty = 4:1,col = c(1,2,3))



#####가설3(계절별 발라드)#####
fit3 <- aov(value ~ season + block,data = final_data3) 

par(mfrow = c(1,1))
#main effect plot
main_effect_season <- tapply(final_data3$value,final_data3$season,mean)
plot(main_effect_season,type = 'b',ylab = 'Value',xlab = 'Season',xaxt = 'n')
axis(1,at = c(1,2,3,4),labels = c('가을','봄','여름','겨울'))

main_effect_block <- tapply(final_data3$value,final_data3$block,mean)
plot(main_effect_block,type = 'b',ylab = 'Value',xlab = 'Block',xaxt = 'n')
axis(1,at = c(1,2,3),labels = c('2021','2022','2023'))



#####가설4(우천별 비 관련 제목)#####
fit4 <- aov(value ~ rain,data = final_data4)

par(mfrow = c(1,1))
#main effect plot
main_effect_rain <- tapply(final_data4$value,final_data4$rain,mean)
plot(main_effect_rain,type = 'b',ylab = 'Value',xlab = 'Rain',xaxt = 'n')
axis(1,at = c(1,2),labels = c('Rain X','Rain O'))



#####가설5(계절, 우천별 댄스락)#####
fit5 <- aov(value ~  rain*summer, data = final_data5)

par(mfrow = c(1,1))
#main effect plot
main_effect_rain <- tapply(final_data5$value,final_data5$rain,mean)
plot(main_effect_rain,type = 'b',ylab = 'Value',xlab = 'Rain',xaxt = 'n')
axis(1,at = c(1,2),labels = c('Rain X','Rain O'))

main_effect_summer <- tapply(final_data5$value,final_data5$summer,mean)
plot(main_effect_summer,type = 'b',ylab = 'Value',xlab = 'Summer',xaxt = 'n')
axis(1,at = c(1,2),labels = c('Summer X','Summer O'))

#interaction plot
interaction.plot(final_data5$summer,final_data5$rain,response = final_data5$value, xlab = 'Rain',ylab = 'Value', main = 'Interaction between rain & summer',type = 'o',legend = F,col = c(1,2), ylim = c(0.624,0.627))
legend('topright',legend = c('summer X','summer O'),cex = 1,lty = 2:1,col = c(1,2))
