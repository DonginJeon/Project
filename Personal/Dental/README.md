# 보험상병명 검색엔진 프로젝트 보고서

## [서비스 링크](https://oasis4dent.com/)

## 느낀점

- 자연어에 대한 처리와 웹 프레임워크를 활용한 실제 웹 서비스 개발에 대한 경험을 해볼 수 있었음. 기본적인 서비스를 구축해도 보완할 점이 많았음. 가령 특정 검색어에서 원하는 결과가 나오지 않을 경우 이를 디버깅하기 위해 수정하는 과정, 디자인적인 부분, 미비한 기능에 대한 보완을 하고 지속적으로 관찰하며 개선하는 경험을 할 수 있었음. 해당 프로젝트를 통해 이용자가 한글로 키워드를 쳤을 때 이를 어느정도 보정해주고 오탈자가 들어와도 제대로 입력되는 기능에 대해 구현해볼 수 있었으며 모듈화를 통해 Django를 효율적으로 사용하여 웹 서비스를 개발하는 경험을 할 수 있었음. 하지만 데이터 자체가 잘 정제되어 있어서 별도의 데이터에 대한 사전 전처리 없이 작업을 진행할 수 있었음.
- 팀플레이로 진행하여 깃허브를 통한 공유 작업을 경험할 수 있었음. 슬랙과 깃허브를 통해 수시로 소통하고 코드를 공유할 수 있었으며 각자의 작업을 브랜치를 따로 파서 합치는 작업도 진행하였음. 슬랙과 깃허브를 연동하여 깃허브에서 푸시를 할때 알림을 통해 볼 수 있었음. 같은 파일을 작업할 때 충돌이 발생하는 상황을 많이 경험했는데 브랜치를 나누었다 합치거나 푸시 알림 등을 통해 이를 극복할 수 있었음. 깃허브를 통한 효율적인 작업 경험과 발생할 수 있는 문제에 대해 경험해 볼 수 있는 기회였음.

---

## 1. 프로젝트 개요

### 1.1 프로젝트 설명

- 실제 치과에서 의뢰가 들어온 프로젝트로 해당 병원에서 사용하는 구글 시트 데이터를 활용하여 검색엔진을 개발하는 프로젝트. 단순 실습이 아닌 웹 프레임워크를 활용하여 실제 치과에서 사용할 수 있는 웹 서비스를 개발하는 것이 목적. [제작 요구사항](./보험%20상병명%20검색%20웹서비스%20제작.docx)에서 실제 치과에서 제공한 제작시 요구사항에 대한 내용을 확인할 수 있음.

### 1.2 프로젝트 배경

- 치과 치료 및 시술에서 치과건강보험 청구시, 해당 진료행위별 산정기준이 정해져 있다. 이 때, 적합한 상병명을 골라야 하지만 이를 손쉽게 검색할 수 있는 검색엔진은 마련되지 않은 상황이다.
  이에 따라, 보험 상병명, 보험 상병 코드, 청구 항목, 상세설명을 검색 및 조회할 수 있는 웹서비스를 제작하여 관련 인력의 편의성을 높일 수 있도록 한다.

### 1.3 목표

- 사용자가 원하는 질병명 또는 청구 항목을 정확하게 검색하고, 관련된 카테고리와 세부 항목을 직관적으로 제공하는 검색 엔진을 구축. 아래는 의뢰인 요구한 3가지 요구사항

  ```
  - 상병명, 진료행위, 청구항목 중 어떤 키워드라도 검색할 수 있어야 하며, 일치하는 대상 전체를 리스트업해 주어야 한다.

  - 검색 시스템은 자연어 처리 모듈을 활용해야 하며, 전일치 검색 이외에도 부분일치, 오탈자 보정 등의 검색 기능을 지원해야 한다.

  - 특정 청구 항목을 선택할 경우, 해당 시술에 대한 상세 정보(워드프레스 정리 문서 참조)를 조회할 수 있어야 한다.
  ```

### 1.4 역할
- **팀장**으로 프로젝트 기획, 구현, 배포 및 협업 총괄
- 구글 시트와 Django를 연동하여 별도의 데이터베이스 없이 실시간 데이터 업데이트 구현
- **검색엔진 핵심 기능 개발**:
    - 오탈자 방지, 초성 검색, 한영 미전환 오류 보정
    - 사용자 친화적인 검색 결과 제공 (상병명, 코드, 청구 항목 등)
- 프론트엔드 개발: 직관적인 UI/UX 설계 및 구현
- 상병명을 클릭하면 관련 링크로 연결되는 기능 추가
- 자연어처리를 활용한 검색 알고리즘 최적화

---

## 2. 주요 기능

### [사용 설명서](./Introduction.pdf) : 웹 구동방법과 웹 인터페이스에 대한 설명. 패키지, 데이터 추가/ 삭제에 대한 내용이 포함되어 있음.

### 2.1 검색 기능

- **검색어 자동완성**: 사용자가 질병명이나 청구 항목을 입력하면 자동완성 기능을 통해 연관된 결과를 제시하여 검색 속도를 높임.
- **카테고리 기반 필터링**: 검색 결과를 주요 카테고리로 구분하여 보다 직관적인 정보 탐색이 가능.
- **색상구분**: 각 카테고리에 고유한 색상을 부여하여 시각적으로 구분할 수 있도록 함.

### 2.2 상세 보기 및 링크 기능

- **세부 정보 링크 제공**: 검색된 항목의 세부 청구 항목을 클릭하면 관련 웹 페이지로 연결되어, 필요한 정보에 빠르게 접근할 수 있음.(의뢰인이 제공한 구글 시트에 상병병과 연결된 링크 데이터가 존재)

### 2.3 사용자 경험 향상 요소

- 다양한 디바이스에서 편리하게 사용할 수 있도록 레이아웃을 최적화.
- 검색 바와 사이드바를 통해 간편하게 카테고리별 접근이 가능.

---

## 3. 사용된 데이터셋

- **구글 스프레드시트 데이터셋**: 주요 질병명, 청구 항목, 세부 항목 URL 등으로 구성된 스프레드시트 데이터를 API를 통해 불러와 사용.
  - 이를 통해 별도의 csv파일을 저장할 필요없이 api키만 있으면 데이터에 접근가능
- **데이터 처리 방법**: 데이터셋을 서버 시작 시 전역 변수로 불러오며, 이를 활용해 검색 및 카테고리 계층 구조를 설정.

---

## 4. 사용된 모델

- **HangulSearch**: 오탈자 방지 및 자동완성을 위한 클래스로 구현. QueryCorrection안에 있으며 가능한 오탈자에 대한 다양한 상황에 대비하여 함수로 정리
- **카테고리 계층 구조 모델**: 상병명은 대분류 , 중분류, 소분류로 구분되어 있는데 이를 효율적으로 검색해보고자 따라 함수로 구현

---

## 5. 진행 과정

### 5.1 초기 설정

1. **Django 애플리케이션 구축**: 검색엔진 애플리케이션을 구성하기 위해 Django 프레임워크를 사용.
2. **데이터 불러오기**: 구글 스프레드시트를 통해 질병명과 청구 항목을 포함한 데이터셋을 호출.(개인 api키 필요 -> key파일로 만들어 장고 폴더안에 위치시키면 사용가능)

### 5.2 검색 로직 구현

1. **QueryCorrection 사용**: 검색어에 오타가 있을 경우 자동으로 수정하며, 질병명과 청구 항목을 정확하게 검색.
2. **카테고리 계층 구조 구성**: 검색 결과에 계층 구조를 반영하여, 주요 카테고리, 중간 및 세부 카테고리를 사용자가 한눈에 파악할 수 있도록 설정.

### 5.3 UI 및 UX 개선

1. **색상 코딩 및 사이드바 구현**: 검색 결과에 색상을 적용하여 카테고리를 시각적으로 구분하고, 사이드바를 통해 접근성을 높임.
2. **반응형 스타일링**: 다양한 화면 크기에 대응할 수 있도록 CSS를 최적화.

## 6. 개선점

### 6.1 성능 최적화

- 검색 알고리즘 개선을 통해 데이터 로딩 속도를 향상시키고, 사용자가 원하는 정보를 더욱 신속하게 찾을 수 있도록 할 필요가 있음.

### 6.2 추가 데이터 활용

- 사용자의 검색 기록을 분석하여 자주 검색되는 질병명 또는 청구 항목을 상위에 표시하는 기능을 도입할 예정.

### 6.3 사용자 맞춤형 기능

- 사용자 맞춤형 추천 기능을 추가하여, 사용자가 자주 검색하는 항목을 저장하고 이를 바탕으로 맞춤형 검색 결과를 제공할 계획.

---

## 7. 결론

본 프로젝트는 보험 질병명 및 청구 항목 검색 과정을 개선하여 사용자 경험을 크게 향상시킴. 향후에는 검색 속도 및 성능 최적화, 사용자 맞춤형 검색 기능 등 추가 기능을 통해 프로젝트를 더욱 발전시킬 예정.

---

## 8. 참고자료

- Django 공식 문서
- 구글 스프레드시트 API
- QueryCorrection 및 HangulSearch 관련 자료
