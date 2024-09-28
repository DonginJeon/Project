
# 갑자기 든 생각 : 이상치 발생을 예측할 수 있을까?
dat_1$피해면적_합계 %>% boxplot()
dat_1$피해면적_합계 %>% sort(decreasing=T) %>% head(10)
dat_1$피해면적_합계 %>% sort(decreasing=T) %>% head(50)
dat_1$피해면적_합계 %>% sort(decreasing=T) %>% length()
# 도대체 어디부터 이상치라 해야할까...
dat_1$피해면적_합계 %>% sort(decreasing=T) %>% head(200)
range(dat_1$피해면적_합계)
range(dat_1$피해면적_합계) %>% diff()
hist_dat <- dat_1$피해면적_합계 %>% hist(plot=F, breaks=10000)
hist_dat$breaks
hist_dat$counts
hist_dat$mids[hist_dat$counts>=2]
# 보면, 피해 면적이 0~20까진 그래도 2개 이상 존재하고
# 그 이상 띄엄띄엄 있다가
# 49, 51에서 발생하고, 67에서 있고, 161에 있다.
hist_dat$mids[hist_dat$counts>=3]
hist_dat$counts[hist_dat$counts>=3]
# 3으로 늘리니까, 걍 피해 면적은 0~20까지만 존재한다.
# 5368개에서 5314개가 이 구간에 속한다.
# 가정 : Left Skewed가 partition으로 존재하는데 그 정도가 너무 심해서
# 보이지 않았다. => 폐기
# 아웃라이어 기준 설정? => over 20이면 outlier.
