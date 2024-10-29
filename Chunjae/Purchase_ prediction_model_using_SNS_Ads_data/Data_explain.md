```
총 54개의 컬럼으로 구성되어 있고 학생에 대한 정보 및 제공되는 서비스에 대한 정보를 나타낸 자료이다. 크게 유저정보, 서비스 유지 형태 및 기간, 포인트, 태블릿, 학습미디어, 비디어, 시험, 오답노트, 기타 의 9개의 대분류로 분류하였고 자세한 설명은 아래에 기재되어 있다.
```

- [컬럼에 대한 설명]

  - 유저 정보

    - userid : 회원아이디
    - gender : 성별
    - membertype_codename : 회원구분 코드의 한글명(학교급) ex. 초등
    - grade_codename : 학년 코드
    - memberstatus : 회원상태 (44:만료, 66:미납\_중지, 88:탈퇴)
    - memberstatus_codename : 회원상태 코드의 한글명
    - memberstatus_change : 월 중 회원상태 변화

  - 서비스 유지 형태 및 기간

    - status_null_count : 회원상태 없음 일수
    - statusgroup_10_count : 임시회원 일수
    - statusgroup_20_count : 무료회원 일수
    - statusgroup_30_count : 유료회원 일수
    - statusgroup_40_count : 중지회원 일수
    - statusgroup_50_count : 만료회원 일수
    - statusgroup_90_count : 해지회원 일수

  - 포인트

    - point_gain_activeday_count : 포인트 획득일수
    - point_gain_count : 포인트 획득 횟수
    - point_gain : 획득 포인트
    - point_loss_activeday_count : 포인트 차감일수
    - point_loss_count : 포인트 차감 횟수
    - point_loss : 차감 포인트

  - 태블릿

    - tablet_activeday_count : 기기 활성 횟수
    - tablet_moved_menu_count : 기기 메뉴이동 횟수
    - tablet_leave_count :기기 물리적 종료 횟수
    - tablet_resume_count : 기기 물리적 재개 횟수
    - tablet_login_count : 로그인 횟수
    - tablet_logout_count : 기기 로그아웃 횟수

  - 학습

    - study_activeday_count :학습 활성일 횟수
    - study_count : 학습 횟수
    - study_notcompleted_count : 학습 미완료 횟수
    - study_completed_count : 학습 완료 횟수
    - study_restart_count : 학습 재시작 횟수
    - total_system_learning_time : 학습 시간합계(시스템)
    - total_caliper_learning_time : 학습 시간합계(캘리퍼)

  - 미디어

    - media_activeday_count : 미디어 활동 활성 일수
    - media_count : 미디어 학습 횟수

  - 비디오

    - video_action_count : 비디오 활동 횟수
    - video_start_count : 비디오 시작 횟수
    - video_restart_count : 비디오 재시작 횟수
    - video_pause_count : 비디오 일시정지 횟수
    - video_jump_count : 비디오 점프 횟수
    - video_resume_count : 비디오 재개(일시정지 후 횟수)
    - video_speed_count : 비디오 속도 조절 횟수
    - video_volume_count : 비디오 볼륨 조절 횟수
    - video_end_count : 비디오 종료 횟수

  - 시험

    - test_activeday_count : 평가 활성 일수
    - test_count : 평가 횟수
    - test_average_score : 평가 평균 점수
    - test_item_count : 평가 문항 개수
    - test_correct_count : 평가 정답 개수

  - 오답노트

    - wrong_count : 오답 노트 진입 횟수
    - wrong_item_count : 오답 노트 문항 개수
    - wrong_correct_count : 오답 노트 정답 개수

  - 기타
    - yyyy : 년
    - mm : 월

[컬럼 자료형]

```
    0   userid                       111082 non-null  object
    1   gender                       111082 non-null  object
    2   membertype_codename          111082 non-null  object
    3   grade_codename               111082 non-null  object
    4   memberstatus                 111082 non-null  int64
    5   memberstatus_codename        111082 non-null  object
    6   memberstatus_change          111082 non-null  object
    7   status_null_count            111082 non-null  int64
    8   statusgroup_10_count         111082 non-null  int64
    9   statusgroup_20_count         111082 non-null  int64
    10  statusgroup_30_count         111082 non-null  int64
    11  statusgroup_40_count         111082 non-null  int64
    12  statusgroup_50_count         111082 non-null  int64
    13  statusgroup_90_count         111082 non-null  int64
    14  point_gain_activeday_count   111082 non-null  float64
    15  point_gain_count             111082 non-null  float64
    16  point_gain                   111082 non-null  float64
    17  point_loss_activeday_count   111082 non-null  float64
    18  point_loss_count             111082 non-null  float64
    19  point_loss                   111082 non-null  float64
    20  tablet_activeday_count       111082 non-null  float64
    21  tablet_moved_menu_count      111082 non-null  float64
    22  tablet_leave_count           111082 non-null  float64
    23  tablet_resume_count          111082 non-null  float64
    24  tablet_login_count           111082 non-null  float64
    25  tablet_logout_count          111082 non-null  float64
    26  study_activeday_count        111082 non-null  float64
    27  study_count                  111082 non-null  float64
    28  study_notcompleted_count     111082 non-null  float64
    29  study_completed_count        111082 non-null  float64
    30  study_restart_count          111082 non-null  float64
    31  total_system_learning_time   111082 non-null  float64
    32  total_caliper_learning_time  111082 non-null  float64
    33  media_activeday_count        111082 non-null  float64
    34  media_count                  111082 non-null  float64
    35  video_action_count           111082 non-null  float64
    36  video_start_count            111082 non-null  float64
    37  video_restart_count          111082 non-null  float64
    38  video_pause_count            111082 non-null  float64
    39  video_jump_count             111082 non-null  float64
    40  video_resume_count           111082 non-null  float64
    41  video_speed_count            111082 non-null  float64
    42  video_volume_count           111082 non-null  float64
    43  video_end_count              111082 non-null  float64
    44  test_activeday_count         111082 non-null  float64
    45  test_count                   111082 non-null  float64
    46  test_average_score           111082 non-null  float64
    47  test_item_count              111082 non-null  float64
    48  test_correct_count           111082 non-null  float64
    49  wrong_count                  111082 non-null  float64
    50  wrong_item_count             111082 non-null  float64
    51  wrong_correct_count          111082 non-null  float64
    52  yyyy                         111082 non-null  int64
    53  mm                           111082 non-null  int64
```
