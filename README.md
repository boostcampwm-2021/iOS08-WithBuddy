#  위드버디

<div align="center"><img src="https://i.imgur.com/2e7YUm2.png" width=100>
    <img src="https://i.imgur.com/VaK4t6s.png" width=100>
    <img src="https://i.imgur.com/YH1zvuk.png" width=100>
    <img src="https://i.imgur.com/CeHxwEX.png" width=100>
    <img src="https://i.imgur.com/HOdXEB0.png" width=100>
    <img src="https://i.imgur.com/IPxujow.png" width=100> <br/> 💜 위드코로나엔 위드버디 💜 </div>

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

|로딩화면|일정화면|통계화면|
|:-:|:-:|:-:|
|<img src="https://user-images.githubusercontent.com/55748244/142988296-9d8cb2c0-6d72-4b5b-ac6a-7f7e3dab8a2f.gif" width=270>|<img src="https://i.imgur.com/95TXoeI.gif" width=200>|<img src="https://i.imgur.com/jw1IzoN.gif" width=200>|
||사용자가 등록한 모임에 대한 내용을 달력화면에서 한번에 확인할 수 있습니다.|사용자가 등록한 모임들에 대한 다양한 통계를 확인할 수 있습니다.|

<!--
|모임등록|버디추가|
|:-:|:-:|
|<img src="https://i.imgur.com/S6S7fzr.gif" width=200>|<img src="https://i.imgur.com/YuaKMHg.gif" width=200>|
|사용자가 원하는 정보를 입력해 새로운 모임을 생성할 수 있습니다.|자유롭게 캐릭터를 커스텀하여 버디를 추가할 수 있습니다.|

|목록화면|설정화면|
|:-:|:-:|
|<img src="https://i.imgur.com/FJ6sUR8.gif" width=200>|<img src="https://i.imgur.com/l8lDmQI.gif" width=200>|
|사용자가 등록한 모임들을 리스트형태로 확인할 수 있습니다.|설정화면에서 다양한 설정을 변경할 수 있습니다|
-->

<br/>

## ✨ Feature

### 일정관리 기능

- 일정 유무에 따라 본인의 캐릭터가 관련 정보를 알려줍니다.
- 달력에서 모임을 가졌던 친구의 캐릭터를 한눈에 확인할 수 있습니다.

### 통계 기능

- 시각화된 그래프를 통해 자신의 만남에 대한 다양한 통계를 확인할 수 있습니다.
    - 가장 많이 만난 친구 순위(버블차트)
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

- 

<br/>

## 📲 설치방법

- [배포링크](https://lunchscreen.github.io/withBuddy/)
- 현재는 CodeSquad 그룹에 소속된 기기만 설치가 가능합니다.
