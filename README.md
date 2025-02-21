[![ko](https://img.shields.io/badge/lang-ko-blue.svg)](https://github.com/iOS05-Stargazers/STAR/blob/develop/README.md)
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/iOS05-Stargazers/STAR/blob/develop/README.en.md)

# 📱 스타 - STAR
STAR: Screen Time Awareness & Regulation (iOS 앱)
<br>
[https://stargazers-star.vercel.app/](https://stargazers-star.vercel.app/)

## 📚 기술 스택
<div>
  <a href="https://developer.apple.com/xcode/" target="_blank">
    <img src="https://img.shields.io/badge/Xcode_16.1-147EFB?style=for-the-badge&logo=xcode&logoColor=white" alt="Xcode">
  </a>
  <a href="https://swift.org/" target="_blank">
    <img src="https://img.shields.io/badge/Swift_5-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
  </a>
  <br>
  <a href="https://developer.apple.com/documentation/xcode/configuring-app-groups" target="_blank">
    <img src="https://img.shields.io/badge/AppGroups-2396F3?style=for-the-badge&logo=apple&logoColor=white" alt="AppGroups">
  </a>
  <a href="https://developer.apple.com/documentation/familycontrols" target="_blank">
    <img src="https://img.shields.io/badge/FamilyControls-2396F3?style=for-the-badge&logo=apple&logoColor=white" alt="FamilyControls">
  </a>
  <br>
    <a href="https://developer.apple.com/documentation/deviceactivity" target="_blank">
    <img src="https://img.shields.io/badge/DeviceActivity-2396F3?style=for-the-badge&logo=apple&logoColor=white" alt="DeviceActivity">
  </a>
  <a href="https://developer.apple.com/documentation/managedsettings" target="_blank">
    <img src="https://img.shields.io/badge/ManagedSettings-2396F3?style=for-the-badge&logo=apple&logoColor=white" alt="ManagedSettings">
  </a>
  <br>
  <a href="https://developer.apple.com/xcode/swiftui/" target="_blank">
    <img src="https://img.shields.io/badge/SwiftUI-2396F3?style=for-the-badge&logo=apple&logoColor=white" alt="SwiftUI">
  </a>
  <a href="https://developer.apple.com/documentation/uikit" target="_blank">
    <img src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=uikit&logoColor=white" alt="UIKit">
  </a>
  <a href="https://github.com/SnapKit/SnapKit" target="_blank">
    <img src="https://img.shields.io/badge/SnapKit-00aeb9?style=for-the-badge&logoColor=white" alt="SnapKit">
  </a>
  <a href="https://github.com/devxoul/Then" target="_blank">
    <img src="https://img.shields.io/badge/Then-00aeb9?style=for-the-badge&logoColor=white" alt="Then">
  </a>
  <a href="https://github.com/ReactiveX/RxSwift" target="_blank">
    <img src="https://img.shields.io/badge/rxswift-B7178C?style=for-the-badge&logoColor=white" alt="rxswift">
  </a>
  <br>
  <a href="https://github.com/" target="_blank">
    <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  </a>
  <a href="https://www.gitkraken.com/" target="_blank">
    <img src="https://img.shields.io/badge/gitkraken-179287?style=for-the-badge&logo=gitkraken&logoColor=white" alt="GitKraken">
  </a>
  <a href="https://git-fork.com/" target="_blank">
    <img src="https://img.shields.io/badge/fork-1c8dfc?style=for-the-badge&logoColor=white" alt="Then">
  </a>
  <br>
</div>

## 👥 팀 소개
| 이름      | GitHub   | 주요 개발 사항 |
|:--------:| -------- |:-----------------:|
| 박유빈 <br> Youbin Park | [@daydreamplace](https://github.com/daydreamplace) | 권한 및 온보딩 화면 <br> 데이터 처리 기반 마련 |
| 서문가은 <br> Gaeun Seomun | [@name-mun](https://github.com/name-mun) | 스타 목록 화면 <br> 스타 목록 핸들링 |
| 안준경 <br> Jungyung Ahn | [@AhnJunGyung](https://github.com/AhnJunGyung) | 스타 생성 및 수정 화면 <br> 사용자 입력 처리 |
| 이재영 <br> Jaeyoung Lee | [@0-jerry](https://github.com/0-jerry) | 데이터 모델 설계 <br> 팀 프로젝트 감독 |
| 황도일 <br> Doyle Hwang | [@DoyleHWorks](https://github.com/DoyleHWorks) | 스크린타임 프레임워크 <br> 공통 UI 컴포넌트 |

## ⏰ 프로젝트 범위
- **시작일**: 2025/01/16

## 📂 폴더 구조
```bash
├── star                       // 프로젝트의 메인 앱
│   ├── App                    // 메타데이터, 권한, 라이프사이클
│   ├── Resource
│   └── Source
│        ├── Core
│        │    ├── Extension    // DeviceActivityName, FamilyActivitySelection, UserDefaults 등의 Extension
│        │    ├── Manager
│        │    │    ├── StarManager           // (UserDefaults)
│        │    │    ├── BlockManager          // (DeviceActivity)
│        │    │    ├── FamilyControlsManager // (FamilyControls, ManagedSettings)
│        │    │    └── NotificationManager   // (UserNotifications)
│        │    └── Theme
│        ├── Model
│        │    ├── Star
│        │    ├── StarListModel
│        │    └── StarState
│        └── Presentation      // 뷰 및 뷰모델
│             ├── AppLaunch
│             ├── CustomView   // 공통 UI 컴포넌트를 비롯한 커스텀 뷰
│             ├── Onboarding
│             ├── Permission
│             ├── Rest
│             ├── StarDeleteAlert
│             ├── StarEdit
│             └── StarList
├── ShieldConfiguration        // 앱 사용 제한 화면인 스크린타임 화면 커스터마이징을 위한 앱 확장
├── ShieldAction               // 스크린타임 화면에서 호출되는 메서드를 관리하는 앱 확장
└── DeviceActivityMonitor      // 생성된 스크린타임 스케줄에 따라 호출되는 메서드를 관리하는 앱 확장
```

## 🖼️ 미리보기

|![Simulator Screenshot - iPhone 16 Pro Max - 2025-02-14 at 21 27 18](https://github.com/user-attachments/assets/82efbe15-dc92-4779-95ad-392bfd9be2ce)|![Simulator Screenshot - iPhone 16 Pro Max - 2025-02-14 at 21 16 32](https://github.com/user-attachments/assets/4749ca58-c445-49af-8d4e-2a52b787200c)|![Simulator Screenshot - iPhone 16 Pro Max - 2025-02-14 at 21 17 43](https://github.com/user-attachments/assets/eb80bbf8-6064-44bb-943d-63e143ad17cd)|![Simulator Screenshot - iPhone 16 Pro Max - 2025-02-14 at 21 18 21](https://github.com/user-attachments/assets/99e29c5d-ec64-4868-9f3e-f9a8be39ae61)|
|---|---|---|---|

## 🏷 주요 기능
#### 스타(Star) - 디지털 시간 관리 유닛
- 사용자는 여러 개의 스타를 생성 및 관리할 수 있습니다.
- 스타는 이름, 차단할 앱 목록, 활성 시간 및 지정 요일을 가지며, 하나의 세션으로서 작동합니다.

#### 스타 관리
- 사용자는 스타 목록에서 스타를 조회하고 추가 또는 삭제할 수 있습니다.
- 기존의 스타를 선택하여 설정을 수정할 수 있습니다.

#### 휴식 모드 전환
- 스타가 활성화되어 있는 동안에도 사용자는 스크린타임 기능을 최대 20분간 일시적으로 비활성화할 수 있습니다.
- 사용자 친화적 플로우를 통해 균형 잡힌 디지털 라이프스타일을 지원합니다.

#### 사용자친화적 제약
- 진행 중인 스타의 삭제 및 수정, 휴식 모드 전환에 일정 시간 기다리게 하는 화면이 삽입됩니다.
- 사용자가 기존에 설정한 목표를 수행할 수 있도록, 적당한 제약을 통해 도와줍니다.

## ✨ 개발 시 고려사항
#### 기능 및 아키텍처
- 데이터 통신: App Group(공유 컨테이너를 통한 UserDefaults 사용)을 통해 메인 앱과 DeviceActivityMonitor 간의 연결
- 핵심 기능: Family Controls (FamilyControls, DeviceActivity, ManagedSettings)를 사용하여 주요 기능 구현
- MVC -> MVVM 리팩터링: MVC로 개발을 시작했으나, 정형화된 데이터 흐름과 역할 분리가 필요해지면서 MVVM으로 리팩터링했습니다.

#### 온보딩 플로우
- 앱이 실행될 때마다 스크린타임 권한을 확인하고, 필요 시 설정 가이드를 제공합니다.
- 처음 사용하는 사용자를 위한 도움말 화면을 제공합니다.

#### 사용자 경험 개선
- 간단한 스와이프 동작과 커스텀 알림을 결합한 안전한 삭제 기능 제공
- Auto Layout를 통한 소형 iPhone 호환성 보장, 편의성을 고려한 버튼 크기 조절

## 🔍 Family Controls 관련 주요 과제
#### 멀티세션 생성 및 관리
- 하나만의 앱 차단 세션을 구현한다면, 그 구현이 비교적 단순하고 추가 타겟이 필요하지 않을 수 있음
- ActivityDeviceMonitor App Extension의 인터벌 생명주기 메서드를 활용해 멀티 세션을 구현
- DeviceActivity의 모니터링 스케줄과 ManagedSettings의 차단할 앱 리스트(FamilyActivitySelection) 적용 로직을 분리해 유연한 관리 가능

#### App Extension에도 Family Controls 요청하기
- App Extension을 활용할 경우 각 번들 ID에 대해서도 Family Controls (Distribution) 권한을 요청하여 승인 받아야 하며, 일반적으로 Apple 측의 답변을 받기까지 1달 이상 소요되는 것으로 보임
- 이에 따라 개발 일정은 메인 앱과 필요한 App Extension에 대한 승인 대기 시간을 고려하여 조정해야 함

#### FamilyActivityPicker의 불안정성 대응
- FamilyActivityPicker 자체가 불안정하여 크래시 발생 가능성이 높으며, 2022년부터 보고된 버그가 현재 기준으로 아직 고쳐지지 않은 상황
- 기본적으로 SwiftUI에서만 지원하기에 UIKit 기반의 코드에서 정상적으로 작동시키는 데 추가적인 처리가 많이 필요할 수 있음
- 크래시 핸들링을 우회적으로 처리함으로써 사용자 경험을 개선할 수 있음

## 📦 설치 방법 
(앱 스토어 출시 준비 중)

1. 리포지토리 클론:  
   ```bash  
   git clone https://github.com/iOS05-Stargazers/STAR.git
   ```  
