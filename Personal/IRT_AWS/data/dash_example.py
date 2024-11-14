# 위 자료는 옛날에 선호도 조사같은 거 할 때 담당자가 스스로 시각화 필터링 할 수 있게 호다닥 세팅해드린거에여
# 선호도 조사같은 경우는 연령대(20,30,40대 등등), 성별, 직무 등등이 있으니...?
# 쨌든 저같은 경우는 생각하기 싫어서... 냅다 value로 지정하고 & 을 이용해서 표기했다만, 메소드를 받아오는 방식으로 설계해도 나쁘지 않을겁니다.

import warnings # warning 문구 보기 싫어서 없애는 라이브러리
import calendar # 캘린더 함수
import openpyxl # 엑셀 참조하기 
import numpy as np 
import pandas as pd
import plotly.express as px
# import dash_bootstrap_components as dbc
from datetime import datetime, timedelta
from plotly.subplots import make_subplots
from dash import Dash, dcc, html, Input, Output

# 칼럼 선택. 이렇게 절대값으로 지정하는 것이 아니라면 filter_list = df.columns 이런식으로 표현할 수 있겠네요
filter_list = ['소속', '직급', '연령대' ,'aws 사용수준', 'aws 관심도', 'aws 교육수강목적', '교육형태', '수강의사', '교육방식', '선호 교육난이도']
df = pd.read_excel('./data.xlsx')

# 관심 서비스 목록
# 데이터 전처리 부분...
inter_df = df.iloc[:, 8:16]
직급_list = df['직급'].dropna().unique().tolist()
연령대_list = df['연령대'].dropna().unique().tolist()
aws_사용수준_list = df['aws 사용수준'].dropna().unique().tolist()
aws_관심도_list = df['aws 관심도'].dropna().unique().tolist()
aws_교육수강목적_list = df['aws 교육수강목적'].dropna().unique().tolist()
교육형태_list = df['교육형태'].dropna().unique().tolist()
수강의사_list = df['수강의사'].dropna().unique().tolist()
교육방식_list = df['교육방식'].dropna().unique().tolist()
선호_교육난이도_list = df['선호 교육난이도'].dropna().unique().tolist()

app = Dash(__name__)

# 레이아웃 정의
app.layout = html.Div([
    html.Span([html.Br(style={"line-height": "15"})]),
    html.H4('(1) 파이차트 : 선호교육과정'),
    html.Span([html.Br(style={"line-height": "40"})]),
    html.H4('※샘플입니다!'),
    html.Span([html.Br(style={"line-height": "40"})]),
    # Graph 컴포넌트
    dcc.Graph(id='pie-chart'),

    # Dropdown 컴포넌트
    # 카테고리 선택 기능
    # 담당자의 원하는대로 필터링
    html.Label("구분", style={'font-size': '30px'}),
    dcc.Dropdown(
        id='category-dropdown1',
        options=[{'label': filter_, 'value': filter_} for filter_ in filter_list],
        value=filter_list[0]
    ),
    html.Span([html.Br(style={"line-height": "20"})]),
    html.Label("직급 필터링 :"),
    dcc.Dropdown(
        id='category-dropdown2',
        options=[{'label': 직급_, 'value': 직급_} for 직급_ in 직급_list],
        value=직급_list[0]
    ),
        html.Span([html.Br(style={"line-height": "20"})]),
        html.Label("연령대 필터링 :"),
        dcc.Dropdown(
            id='category-dropdown3',
            options=[{'label': 연령대_, 'value': 연령대_} for 연령대_ in 연령대_list],
            value=연령대_list[1]
        ),

    html.Span([html.Br(style={"line-height": "20"})]),
        html.Label("aws_사용수준 필터링 :"),
        dcc.Dropdown(
            id='category-dropdown4',
            options=[{'label': aws_사용수준_, 'value': aws_사용수준_} for aws_사용수준_ in aws_사용수준_list],
            value=aws_사용수준_list[1]
        ),

    html.Span([html.Br(style={"line-height": "20"})]),
        html.Label("aws_관심도 필터링 :"),
        dcc.Dropdown(
            id='category-dropdown5',
            options=[{'label': aws_관심도_, 'value': aws_관심도_} for aws_관심도_ in aws_관심도_list],
            value=aws_관심도_list[2]
        ),

    # html.Span([html.Br(style={"line-height": "20"})]),
    #     html.Label("aws_교육수강목적 필터링 :"),
    #     dcc.Dropdown(
    #         id='category-dropdown6',
    #         options=[{'label': aws_교육수강목적_, 'value': aws_교육수강목적_} for aws_교육수강목적_ in aws_교육수강목적_list],
    #         value=aws_교육수강목적_list[0]
    #     ),

    # html.Span([html.Br(style={"line-height": "20"})]),
    #     html.Label("교육형태 필터링 :"),
    #     dcc.Dropdown(
    #         id='category-dropdown7',
    #         options=[{'label': 교육형태_, 'value': 교육형태_} for 교육형태_ in 교육형태_list],
    #         value=교육형태_list[0]
    #     ),

    # html.Span([html.Br(style={"line-height": "20"})]),
    #     html.Label("수강의사 필터링 :"),
    #     dcc.Dropdown(
    #         id='category-dropdown8',
    #         options=[{'label': 수강의사_, 'value': 수강의사_} for 수강의사_ in 수강의사_list],
    #         value=수강의사_list[0]
    #     ),

    # html.Span([html.Br(style={"line-height": "20"})]),
    #     html.Label("교육방식 필터링 :"),
    #     dcc.Dropdown(
    #         id='category-dropdown9',
    #         options=[{'label': 교육방식_, 'value': 교육방식_} for 교육방식_ in 교육방식_list],
    #         value=교육방식_list[0]
    #     ),

    # html.Span([html.Br(style={"line-height": "20"})]),
    #     html.Label("선호_교육난이도 필터링 :"),
    #     dcc.Dropdown(
    #         id='category-dropdown10',
    #         options=[{'label': 선호_교육난이도_, 'value': 선호_교육난이도_} for 선호_교육난이도_ in 선호_교육난이도_list],
    #         value=선호_교육난이도_list[0]
    #     ),

])

# 콜백 함수를 사용하여 Dropdown의 선택에 따라 파이 차트 업데이트
@app.callback(
    Output('pie-chart', 'figure'),
    Input('category-dropdown1', 'value'),
    Input('category-dropdown2', 'value'),
    Input('category-dropdown3', 'value'),
    Input('category-dropdown4', 'value'),
    Input('category-dropdown5', 'value'),
    # Input('category-dropdown6', 'value'),
    # Input('category-dropdown7', 'value'),
    # Input('category-dropdown8', 'value'),
    # Input('category-dropdown9', 'value'),
    # Input('category-dropdown10', 'value'),
)
def update_pie_chart(selected_category1, selected_category2, selected_category3,selected_category4,selected_category5):
# def update_pie_chart(selected_category1, selected_category2, selected_category3,selected_category4,selected_category5,selected_category6,selected_category7,selected_category8,selected_category9,selected_category10):
    filtering_df = df[(df['직급'] == selected_category2) & (df['연령대'] == selected_category3) & (df['aws 사용수준'] == selected_category4) & (df['aws 관심도'] == selected_category5)]
    # filtering_df = df[(df['직급'] == selected_category2) & (df['연령대'] == selected_category3) & (df['aws 사용수준'] == selected_category4) & (df['aws 관심도'] == selected_category5) & (df['aws 교육수강목 적'] == selected_category6) & (df['교육형태'] == selected_category7) & (df['수강의사'] == selected_category8) & (df['교육방식'] == selected_category9) & (df['선호 교육난이도'] == selected_category10)]
    # filtering_df = df[df['직급'] == selected_category2]

    fig = px.pie(filtering_df, names=selected_category1, title=f'{selected_category1}별 필터링')
    return fig

# 애플리케이션 실행
if __name__ == '__main__':
    # app.run_server(debug=True)
    app.run_server(debug=True, host='0.0.0.0', port=9896)