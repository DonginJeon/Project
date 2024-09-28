# 필요할때 쓰는 EDA plot
library(magrittr)
# View(dat_raw)
head(dat_raw)
dat_raw$발생일시_월 %>%
    table() %>%
    barplot()
# 음... 34월 극도로 높고 789월 극도로 낮네
# 아마 습도차이가 가장 크겠다 싶음
# 피해 면적을 함 보자. 아마 극단적 skewed분포일듯
# 아주 사소한 불이 많을거고, 엄청 큰 피해의 불이 몇번 있으니.
dat_raw$피해면적_합계 %>% head() # chr? 왜지?
# 데이터 가져올때 뭔가 숫자가 아닌 값이 있었나? 
# 함 직접 보고싶은데. 몇개나 되지?
dat_raw$피해면적_합계 %>%
    unique() %>%
    length() # 얼마 안되네
dat_raw$피해면적_합계 %>%
    unique() %>%
    sort() # 딱히 뭐 숫자가 아닌 값은 안보이네.
dat_raw$피해면적_합계 %>%
    is.na() %>% mean() # 빈 값도 없고.
dat_raw$피해면적_합계 %>%
    as.numeric() %>% boxplot()
# 예상대로, 극단값에 의해 치우쳐진 분포다.
# 5000 컷으로 다시 한번 plotting 해보자
dat_raw$피해면적_합계 <- as.numeric(dat_raw$피해면적_합계) # 일단 변환 해주고
under_5000 <- (dat_raw$피해면적_합계 < 5000)
dat_raw$피해면적_합계[under_5000] %>% hist()
dat_raw$피해면적_합계[under_5000] %>% boxplot()
# .... 다시 컷해보자. 
dat_raw$피해면적_합계 %>% 
    quantile(probs = seq(from=0.5,
                         to=1, length.out=6))
# 적절한 cut을 보기 위해 quantile을 보니까, 90%까지 매우 작은 값을 가진다.
dat_raw$피해면적_합계 %>% 
    quantile(probs = seq(from=0.5,
                         to=1, by=0.05))
# 더 세부적으로 보니까, 95% 컷이 2다. 그냥 여기까지 잘라서 봐보자.
under_0.95 <- (dat_raw$피해면적_합계<=2)
dat_raw$피해면적_합계[under_0.95] %>% hist()

