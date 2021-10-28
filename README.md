#  위드버디

<div align="center"><img src="https://i.imgur.com/wbWfU5d.png" width=250><br/>💜 위드코로나엔 위드버디 💜 </div>

<br/>

## 👫🏻 위드버디 소개

친구들과의 일정과 추억을 캐릭터와 함께 기록해 관리할 수 있는 서비스입니다.

<br/>

## 👨‍👩‍👧‍👦 팀원 소개

|```S005``` 김두연|```S020``` 박인우|```S021``` 박정아|```S036``` 이나정|
|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/63900674?s=400&v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/70463738?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/28800101?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/55748244?v=4" width=100>|
|[duyeonnn](https://github.com/duyeonnn)|[inuinseoul](https://github.com/inuinseoul)| [co3oing](https://github.com/co3oing) |[dailynj](https://github.com/dailynj)|

<br/>

## 📱 Preview

<br/>

## ✨ Feature

### 일정관리 기능

- 일정 유무에 따라 본인의 캐릭터가 관련 정보를 알려줍니다.
- 달력에서 모임을 가졌던 친구의 캐릭터를 한눈에 확인할 수 있습니다.

### 통계 기능

- 시각화된 그래프를 통해 자신의 만남에 대한 다양한 통계를 확인할 수 있습니다.
    - 가장 많이 만난 친구 순위
    - 내가 모임을 가지는 목적 순위
    - 가장 최근에 만난 친구 / 만난지 가장 오래된 친구

### 기록 기능

- 모임의 날짜, 장소, 목적, 만난 사람, 메모, 사진을 저장해 친구와의 만남을 기록할 수 있습니다.
- 색상과 표정으로 친구의 캐릭터를 직접 만들 수 있습니다.

<br/>

## 📁 프로젝트 구조

- **MVVM Clean Architecture**를 기본으로 하고 진행하면서 개선

```
Application
    - launchScreen
    - AppDelegate
    - SceneDelegate
    - Asset
    
Domain
    - Entities
    - UseCases
    - Interfaces
        - Repositories
        
Presentation
    - Common View
    - Scene # 1
        - View
          - xxViewController
          - xxView
        - ViewModel
          - TestMock UseCase
    - Scene # 2
        - View
          - xxViewController
          - xxView
        - ViewModel

Data
    - Repositories
    - PersistentStorage
```
 
<br/>
 
## ⚙️ 프레임워크

<br/>

## 💪 기술적 도전

<br/>

## 📲 설치방법
