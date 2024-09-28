
rm(list=ls())

##################################
##################### 데이터 불러오기
##################################
datadir <- "C:/Users/p5682/Documents/카카오톡 받은 파일/sanbul.xls"
dat_raw <- readxl::read_excel(datadir, skip=1)

clim_all_raw <- data.frame()
for (i in 2013:2022) {
    tempRead <- read.csv(paste0("C:/Users/p5682/Downloads/clim", i, ".csv"), header=T,
                         fileEncoding='euc-kr')
    clim_all_raw = rbind(clim_all_raw, tempRead)
}
rm(datadir, tempRead)
clim_all_raw <- tibble(clim_all_raw)






##################################
###################### 데이터 전처리
##################################

common_addr <- intersect(unique(clim_all_raw$지점명),
                         unique(dat_raw$발생장소_시군구))

clim_all_raw %>%
    filter(지점명 %in% common_addr) %>%
    mutate(loc = 지점명,
           date = ymd_hm(일시),
           celcius = 기온..C.,
           wind = 풍속.m.s.,
           humidity = 습도...,
           atm = 현지기압.hPa.,
           surf_temp = 지면온도..C.) %>%
    select(loc, date, celcius, wind, humidity, atm, surf_temp) -> wip_clim1

## wip_clim1은 강원지역 기후 통합자료(10년어치 시간별로)
dat_raw %>%
    mutate(ym = ymd_hm(paste(발생일시_년, '-', 발생일시_월, '-', 발생일시_일,
                             ' ', 발생일시_시간)),
           피해면적_합계 = as.numeric(피해면적_합계)) %>%
    filter(발생장소_시도 == '강원') %>%
    filter(발생장소_시군구 %in% common_addr) %>%
    select(ym, 피해면적_합계, 발생장소_시군구) %>%
    mutate(dmg = 피해면적_합계,
           loc = 발생장소_시군구) %>%
    select(ym, dmg, loc) %>%
    mutate(groupId = row_number()) -> wip_fire0
## wip_fire0은 화재 시각, 피해량, 위치 자료 subject to 강원 location
wip_fire0 %>%
    mutate(mins = as.numeric(difftime(ym, floor_date(ym, unit='hour')), unit='mins'),
           date = ym,
           date_h = floor_date(ym, unit='hour')) %>%
    group_by(groupId) %>%
    select(date_h, mins, dmg, loc, groupId) %>%
    mutate(loc_date = paste0(loc, '/', date_h)) %>%
    .[rep(seq_len(nrow(.)), each = 2), ] %>%
    mutate(ind = ifelse(row_number()%%2==0, 1, 0)) %>%
    mutate(date_h = date_h+hours(ind),
           loc_date = paste0(loc, '/', date_h)) -> wip_fire1
# View(wip_fire1)
wip_clim1 %>%
    mutate(loc_date = paste0(loc, '/', date)) -> wip_clim1
# View(wip_clim1)
wip_join1 <- left_join(wip_fire1, wip_clim1, by='loc_date')
# View(wip_join1)
wip_join1 %>%
    select(date_h, mins, dmg, loc.x, groupId,
           celcius, wind, humidity, atm, surf_temp) %>%
    mutate(diff_celcius = diff(celcius),
           diff_wind = diff(wind),
           diff_humidity = diff(humidity),
           diff_atm = diff(atm),
           diff_surf = diff(surf_temp)) %>%
    mutate(adj_celcius = celcius + diff_celcius*mins/60,
           adj_wind = wind + diff_wind*mins/60,
           adj_humidity = humidity + diff_humidity*mins/60,
           adj_atm = atm + diff_atm*mins/60,
           adj_surf = surf_temp + diff_surf*mins/60) %>%
    ungroup() %>%
    filter(row_number() %% 2 != 0) %>%
    mutate(date = date_h + minutes(mins),
           loc = loc.x) %>% 
    select(date, dmg, loc,
           adj_celcius, adj_wind, adj_humidity, 
           adj_atm, adj_surf) -> dat_clim
rm(list=ls(pattern = "^wip_"))
# write.csv(dat_clim, "./fire_climate.csv")

