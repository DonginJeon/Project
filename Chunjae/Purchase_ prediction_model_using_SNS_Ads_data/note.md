- 데이터셋 : 만료및탈퇴회원
# 분석방향
    - 아이디어1.
        - 서비스 이용시 사용 기간별 태블릿 등 이용 성실도 파악
        - 위 결과가 어떻게 성적에 영향을 주는가
    - 아이디어2.
        - 탈퇴 사유파악? -> 일정 학년이 되면? -> 대부분 중1정도까지 서비스를 이용하는 것같고 항상 서비스의 품질을 보는 듯함.
    - 아이디어3.
        - 만료된 회원을 어떻게 잡아둘 수 있는가(초6에서 중1로 가는과정에서 이탈하는 고객을 잡을 수 있는가)


# 탐색
    - 데이터프레임 형태 : (111851, 54)
        - 유저정보(id, 성별, 학년, 현재 이용 상태)
            - 44:만료
            - 66:미납_중지
            - 88:탈퇴
        - 유지 기간
            - status_null_count : 회원상태 없음 일수
            - statusgroup_10_count : 임시회원 일수
            - statusgroup_20_count : 무료회원 일수
            - statusgroup_30_count : 유료회원 일수
            - statusgroup_40_count : 중지회원 일수
            - statusgroup_50_count : 만료회원 일수
            - statusgroup_90_count : 해지회원 일수

            ```
            임시회원 일수 평균: 0.0
            무료회원 일수 평균: 3.1866459012261212
            유료회원 일수 평균: 1.9200410507552979
            중지회원 일수 평균: 0.17653625249815452
            만료회원 일수 평균: 23.67010856844493
            해지회원 일수 평균: 0.07267604112277416
            ```
        - 점수
        - 태블릿(이용기기) 사용정보
        - 공부 정보(한 기간, 완료, 미완료)
        - 비디오 이용
        - 시험
        - 오답
    - 중복값X
    - 결측치
        - 회원의 정보엔 결측치도 중복값도 없음, 즉 개인에 대한 정보는 충분
        - 서비스 이용에 가면서 결측치가 발생
        - 컬럼
        ```
            point_gain_activeday_count       3955
            point_gain_count                 3955
            point_gain                       3955
            point_loss_activeday_count       3955
            point_loss_count                 3955
            point_loss                       3955
            tablet_activeday_count          69893
            tablet_moved_menu_count         69893
            tablet_leave_count              69893
            tablet_resume_count             69893
            tablet_login_count              69893
            tablet_logout_count             69893
            study_activeday_count           77821
            study_count                     77821
            study_notcompleted_count        77821
            study_completed_count           77821
            study_restart_count             78457
            total_system_learning_time      78584
            total_caliper_learning_time     78496
            media_activeday_count           79605
            media_count                     79605
            video_action_count              80735
            video_start_count               80735
            video_restart_count             80735
            video_pause_count               80735
            video_jump_count                80735
            video_resume_count              80735
            video_speed_count               80735
            video_volume_count              80735
            video_end_count                 80735
            test_activeday_count            82852
            test_count                      82852
            test_average_score              82852
            test_item_count                 83472
            test_correct_count              83472
            wrong_count                    104408
            wrong_item_count               104408
            wrong_correct_count            104408
        ```

        - 같은 결측치에서 현재 상태로 나눈 그룹에 따라 결측값이 같음. 뭔가 상태와 결측치 간의 연관이 있다.

        - 컬럼의 카테고리가 비슷하면 같은 수의 결측치가 발생. 또한 테블릿을 이용하지 않으면 이후 서비스는 이용하지 않는 것으로 생각. 즉 결측치는 해당 서비스를 이용하지 않은 고객이라고 추측
        => 결측치는 0으로 대체
# 전처리
- 학년을 중1이하로 줄임. 4~6세까지도 고학년과 비슷한 비율을 보여 제외. 결측치가 줄긴했지만 다른 방법이 추가로 필요


# EDA
- 각 그룹별(44,66,88) 유지 기간의 차이
- 학년별 회원상태의 차이
    - 키즈~초6까지의 회원이 압도적으로 많고 대부분 만료인 상태. 탈퇴가 가장 적으며 미납이랑 비슷한 수를 보여줌. 고학년에선 수 자체가 압도적으로 줄어듧(중1까지 고려해보면 좋을 거 같다)
    - 단순 시각화에선 초4,초5,초6에서 비슷한 수의 미납 회원수와 나머지 학년으로 구분 가능
    - 저학년에서 만료 수가 12500을 넘어간다는 것은 다양한 서비스를 체험하고 아이에게 맞는 서비스를 찾아주려는 것 아닐까? 즉 특정학년까지 지속적으로 남아있기보다는 서비스의 품질, 아이의 성장을 고려하여 언제든 다른 서비스로 이탈할수도 있다는 의미?
    