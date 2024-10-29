import streamlit as st
import pandas as pd
import altair as alt

import streamlit as st
import pandas as pd
import altair as alt

# Streamlit 앱 설정
st.title("사용자 데이터 시각화 대시보드")
st.sidebar.title("필터")

# 데이터 
data = {
    "age_category": ["10대", "20대", "30대", "10대", "10대", "20대", "40대", "50대", "20대", "10대"],
    "sex": ["M", "F", "M", "M", "M", "F", "M", "F", "M", "M"],
    "city": ["서울", "부산", "서울", "대구", "대구", "서울", "인천", "인천", "울산", "서울"]
}

df = pd.DataFrame(data)

# 나이대 필터
age_category = st.sidebar.multiselect("나이대 선택", df["age_category"].unique(), default=df["age_category"].unique())
filtered_data = df[df["age_category"].isin(age_category)]

# 1. 나이대별 인원수 시각화
age_chart = (
    alt.Chart(filtered_data)
    .mark_bar()
    .encode(
        x=alt.X("age_category", sort='-y', title="나이대"),
        y=alt.Y("count()", title="인원수"),
        color="age_category"
    )
    .properties(title="나이대별 인원 분포")
)

# 2. 성별 인원수 시각화
gender_chart = (
    alt.Chart(filtered_data)
    .mark_bar()
    .encode(
        x=alt.X("sex", title="성별"),
        y=alt.Y("count()", title="인원수"),
        color="sex"
    )
    .properties(title="성별 인원 분포")
)

# 3. 지역별 인원수 시각화
region_chart = (
    alt.Chart(filtered_data)
    .mark_bar()
    .encode(
        x=alt.X("city", sort='-y', title="지역"),
        y=alt.Y("count()", title="인원수"),
        color="city"
    )
    .properties(title="지역별 인원 분포")
)

# Streamlit에 차트 표시
st.altair_chart(age_chart, use_container_width=True)
st.altair_chart(gender_chart, use_container_width=True)
st.altair_chart(region_chart, use_container_width=True)


### 실행 : streamlit run app.py