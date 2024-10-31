# 요약

- mysql, postgresql을 활용하여 fake데이터를 생성하고 데이터프레임으로 만들어 데이터베이스에 저장하는 파이프라인을 구성하는 프로젝트

# 목표

- 각 과정을 모듈화를 통해 효율적으로 구성 시도
- 최대한 함수로 작성하여 기능을 구현 시도
- 파이썬에서 postgresql, mysql을 연결하고 쿼리를 따로 작성하여 이를 통해 데이터를 다루는 경험을 하고자 함.

# Flow chart

![플로우차트](./Untitled%20diagram-2024-10-29-113434.png)

# 흐름

Faker를 통하여 ["name", "ssn", "job", "residence", "blood_group", "sex", "birthdate"] 컬럼으로 이루어진 데이터 프레임을 생성합니다. randint를 통하여 매번 랜덤한 숫자의 정보가 추가되도록 지정하였습니다. 이렇게 생성된 데이터프레임은 fake라는 이름의 테이블로 데이터베이스로 적재됩니다. 간단한 전처리 과정을 거쳐 데이터마트로 저장할 수 있는 process과정도 존재하지만 해당 파이프라인 기능에 구현되어 있지는 않습니다. 이렇게 저장된 데이터 프레임은 mysql을 통하여 적재를 했고 postgresql로도 적재할 수 있습니다. sql접속에 대한 정보는 .env파일에 개인정보를 넣고 DBconnector를 통하여 호출되게 하였습니다. 또한 controller를 통하여 로컬에 저장했다가 sql로 적재하는 방법도 구현되어 있습니다. sql에 적재가 완료되면 로컬에 저장되어 있던 파일은 지워집니다. batch_date를 통해 파이프라인이 돌아가는 연월일이 기록됩니다. 모든 과정을 마치면 DB에서 데이터가 생성된 것을 볼 수 있습니다.

# 폴더 설명

```
Pipeline/
|-- dataset/                           # 데이터셋이 저장되는 폴더
|   |-- data-01/                       # 데이터셋의 하위 폴더
|       |-- names.csv                  # 인물정보가 저장된 CSV 파일
|       |-- test1.csv                  # 테스트 데이터 1이 저장된 CSV 파일
|       |-- test2_kor.csv              # 한국어로 된 테스트 데이터가 저장된 CSV 파일
|       |-- test2.csv                  # 테스트 데이터 2가 저장된 CSV 파일
|       |-- test3.csv                  # 테스트 데이터 3이 저장된 CSV 파일
|       |-- tips.csv                   # 다양한 테스트용 데이터를 포함한 CSV 파일
|-- db/                                # 데이터베이스 관련 파일들이 저장되는 폴더
|   |-- __pycache__/
|   |-- __init__.py
|   |-- connector.py                   # 데이터베이스 연결을 처리하는 파일
|   |-- mysql_query.py                 # MySQL 데이터베이스 쿼리를 저장하는 파일(fake테이블을 조회하는 쿼리만 존재)
|   |-- pgsql_query.py                 # PostgreSQL 데이터베이스 쿼리를 저장하는 파일(fake테이블을 조회하는 쿼리만 존재)
|-- fakedata/                          # Fake 데이터를 생성하고 처리하는 파일들이 저장된 폴더
|   |-- __pycache__/
|   |-- __init__.py
|   |-- create.py                      # Fake 데이터를 생성하는 파일
|   |-- insert.py                      # 생성된 Fake 데이터를 데이터베이스에 삽입하는 파일
|   |-- process.py                     # 행에 대한 간단한 전처리를 실행하는 파일
|-- pipeline/                          # 파이프라인 구성 및 관련 기능을 포함하는 폴더
|   |-- __pycache__/
|   |-- __init__.py
|   |-- extract.py                     # 데이터 추출 기능을 구현한 파일
|   |-- load.py                        # 데이터를 로드하는 기능을 구현한 파일
|   |-- remove.py                      # 데이터를 삭제하거나 정리하는 기능을 구현한 파일
|   |-- transform.py                   # 데이터 변환을 담당하는 파일
|-- temp_storage/                      # 임시 파일을 저장하기 위한 폴더
|-- .env                               # 민감한 정보를 저장
|-- app.py                             # 시각화
|-- controller.py                      # 데이터 파이프라인을 제어하는 컨트롤러 스크립트
|-- main.py                            # 파이프라인 실행을 위한 메인 스크립트
|-- Readme.md                          # 프로젝트 설명
|-- settings.py                        # .env안에 작성된 내용을 dotenv으로 가져오기 위한 파일. sql정보를 불러오는 문서
|-- test_code.ipynb                    # 코드 작성 간 활용한 주피터 파일.
```
