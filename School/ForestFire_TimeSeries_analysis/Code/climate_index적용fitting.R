# fitting with indexing
dat_clim %>%
    select(-loc) %>%
    filter(dmg <= 500) %>%
    mutate(ind1 = case_when(wind <= 3.7 ~ 0,
                            wind > 3.7 ~ 1),
           ind2 = case_when(humid <= 29 ~ 1,
                            humid > 29 ~ 0),
           dmg_ind = case_when(dmg <= 1.4 ~ 0,
                               dmg > 1.4 ~ 1)) %>%
    mutate(ind = ind1+ind2) %>%
    select(-ind1, -ind2) -> dat_fit

t <- as.numeric(dat_fit$date)
t
fit_trend <- lm(dat_fit$dmg~t+0)
plot(dat_fit$dmg~t)
abline(a=fit_trend$coefficients, b=0, col='red')
summary(fit_trend)
plot(fit_trend$residuals)
acf(fit_trend$residuals)

#
clim_all %>%
    filter(!if_any(everything(), is.na)) %>%
    select(-loc_id, -loc_name) %>%
    mutate(y = year(date), m = month(date)) %>%
    mutate(ym = paste0(y, '-', m)) %>%
    group_by(ym) %>%
    mutate(cel = mean(celcius),
           wind = mean(wind),
           humid = mean(humid),
           hpa = mean(hpa),
           surf = mean(surf)) %>%
    select(-date, -celcius, -y, -m) %>%
    unique() -> clim_bymonth
colnames(clim_bymonth) = c("wind_all_month", "humid_all_month", "hpa", "surf", "ym" ,"cel_all_month")
clim_bymonth <- clim_bymonth %>%
    select(ym, wind_all_month, humid_all_month, cel_all_month)
clim_bymonth
dat_clim %>%
    filter(dmg <= 500) %>%
    mutate(ym = paste0(year(date), '-', month(date))) %>%
    select(ym, dmg, wind, humid, cel) -> dat_clim_dwh_ym
clim_bymonth %>%
    left_join(., dat_clim_dwh_ym, by='ym') %>%
    mutate(dmg = ifelse(is.na(dmg), 0, dmg),
           wind = ifelse(is.na(wind), wind_all_month, wind),
           humid = ifelse(is.na(humid), humid_all_month, humid),
           cel = ifelse(is.na(cel), cel_all_month, cel)) %>%
    #select(-cel_all_month) %>%
    mutate(dmg_ind = ifelse(dmg>=1.4, 1, 0),
           wind_over = ifelse(wind >= 3.7, 1, 0),
           humid_lower = ifelse(humid <= 29, 1, 0),
           cel_0 = ifelse(cel<=0, -1, 0),
           wind_over_m = ifelse(wind >= wind_all_month, 1, 0),
           humid_lower_m = ifelse(humid <= humid_all_month, 1, 0),
           cel_lower_m = ifelse(cel <= cel_all_month, 1, 0)) %>%
    select(-wind_all_month, -humid_all_month, -cel_all_month) %>%
    group_by(ym) %>%
    mutate(ym = ym(ym),
           dmg = mean(dmg),
           dmg_ind = mean(dmg_ind),
           wind = mean(wind),
           humid = mean(humid),
           cel = mean(cel),
           wind_over = mean(wind_over),
           humid_lower = mean(humid_lower),
           cel_0 = mean(cel_0),
           wind_over_m = mean(wind_over_m),
           humid_lower_m = mean(humid_lower_m),
           cel_lower_m = mean(cel_lower_m)) %>%
    unique() -> dat_ind
# wind 3.7 humid 29 dmg 1.4를 기반으로.
dat_ind %>%
    mutate(ind = wind_over + humid_lower,
           ind_c = wind_over+humid_lower+cel_0,
           ind_comp = wind_over_m+wind_over+humid_lower+humid_lower_m+cel_0+cel_lower_m) %>%
    ungroup() %>%
    select(dmg_ind, ind_c, ind_comp) %>%
    mutate(ind_comp = ifelse(ind_comp<=0, 0, ind_comp),
           ind_c = ifelse(ind_c <= 0, 0, ind_c)) -> temp_a
cor(temp_a)

dat_ind
dat_ind2 <- dat_ind %>%
    mutate(dmg = ifelse(dmg >= 1.4, 1.4, dmg))
dmg_mean.ts <- ts(dat_ind2$dmg, start=c(2013, 1), frequency=12)
dmg_mean.ts
t = 1:length(dmg_mean.ts)
fit1 <- lm(dmg_mean.ts ~ t)
summary(fit1)
ts.plot(dmg_mean.ts,
        fit1$fitted.values, col=1:2, lty=1:2)
ts.plot(resid(fit1))
acf(fit1$residuals)
pacf(fit1$residuals)
# 여기까지가 trend.
# seasonality modeling preprocessing
dmg_mean.ts_noTrend <- dmg_mean.ts-fit1$fitted.values
I = factor(cycle(dmg_mean.ts_noTrend))
Imat_ = model.matrix(~I+0)
fit2 <- lm(dmg_mean.ts_noTrend~Imat_+0)
ts.plot(dmg_mean.ts, fit1$fitted.values+fit2$fitted.values,
        col=1:2, lty=1:2)
summary(fit2)
ts.plot(fit2$residuals,
        main = '[z_t = T + S + err] model resid plot')
abline(h=0, col=2, lty=2)
acf(fit2$residuals, lag.max=12)
pacf(fit2$residuals, lag.max=12)
mse_model2 = sum(fit2$residuals^2)
mse_model2

dat_ind2 %>%
    mutate(ind = wind_over+humid_lower+cel_0) %>%
    ungroup() %>%
    select(dmg_ind, ind) %>%
    mutate(ind = ifelse(ind <= 0, 0, ind)) %>%
    .$ind -> climate_ind
climate_ind

###
dmg_mean.ts_noTS <- dmg_mean.ts-fit1$fitted.values-fit2$fitted.values
fit3 <- lm(dmg_mean.ts_noTS~climate_ind)
ts.plot(dmg_mean.ts, fit1$fitted.values+fit2$fitted.values+fit3$fitted.values,
        col=1:2, lty=1:2)
summary(fit3)
ts.plot(fit3$residuals,
        main = '[z_t = T + S Cli + err] model resid plot')
abline(h=0, col=2, lty=2)
acf(fit3$residuals, lag.max=12)
pacf(fit3$residuals, lag.max=12)
mse_model3 = sum(fit3$residuals^2)
mse_model2 ; mse_model3

climate_ind2 = climate_ind + 1
length(I)
length(climate_ind2)
Imat_clim = model.matrix(~climate_ind2+0)
fit4 <- lm(dmg_mean.ts ~ (t+Imat_+0)*(climate_ind2))
#fit4 <- lm(dmg_mean.ts ~ (t+Imat_clim+0))
fit_nocli <- lm(dmg_mean.ts~t+Imat_+0)
summary(fit4)
ts.plot(dmg_mean.ts, fit4$fitted.values, fit_nocli$fitted.values,
        col=1:3, lty=1:3)
sum(resid(fit4)^2)
sum(resid(fit_nocli)^2)
mse_model2

clim_bymonth %>%
    mutate(ym = ym(ym)) %>%
    filter(year(ym) %in% c(2014, 2015)) %>%
    print(n=50)
dat_clim_dwh_ym %>%
    mutate(ym = ym(ym)) %>%
    filter(year(ym) %in% c(2014, 2015)) %>%
    group_by(ym) %>%
    print(n=50)
