[![ko](https://img.shields.io/badge/lang-ko-blue.svg)](https://github.com/iOS05-Stargazers/STAR/blob/develop/README.md)
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/iOS05-Stargazers/STAR/blob/develop/README.en.md)

# 📱 스타(STAR)
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
  <br>
  <a href="https://github.com/ReactiveX/RxSwift" target="_blank">
    <img src="https://img.shields.io/badge/reactivex-B7178C?style=for-the-badge&logoColor=white" alt="reactivex">
  </a>
    <a href="https://github.com/RxSwiftCommunity/RxKeyboard" target="_blank">
    <img src="https://img.shields.io/badge/rxkeyboard-B7178C?style=for-the-badge&logoColor=white" alt="rxkeyboard">
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
| Name     | GitHub   | Main Developments |
|:--------:| -------- |:-----------------:|
| 박유빈 <br> Youbin Park | [@daydreamplace](https://github.com/daydreamplace) | 권한 및 온보딩 화면 <br> 데이터 처리 기반 마련 |
| 서문가은 <br> Gaeun Seomun | [@name-mun](https://github.com/name-mun) | 스타 목록 화면 <br> 스타 목록 핸들링 |
| 안준경 <br> Jungyung Ahn | [@AhnJunGyung](https://github.com/AhnJunGyung) | 스타 생성 및 수정 화면 <br> 사용자 입력 처리 |
| 이재영 <br> Jaeyoung Lee | [@0-jerry](https://github.com/0-jerry) | 데이터 모델 설계 <br> 팀 프로젝트 감독 |
| 황도일 <br> Doyle Hwang | [@DoyleHWorks](https://github.com/DoyleHWorks) | 스크린타임 프레임워크 <br> 공통 UI 컴포넌트 |

## ⏰ 프로젝트 범위
- **시작일**: 2025/01/16

## 📂 Folder Organization
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
│             └── StarListI
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
- 사용자는 스타 목록에서 스타를 조회하고 추가할 수 있습니다.
- 기존의 스타를 선택하여 설정을 수정할 수 있습니다.

#### 휴식 모드 전환
- 스타가 활성화되어 있는 동안에도 사용자는 스크린타임 기능을 최대 20분간 일시적으로 비활성화할 수 있습니다.
- 사용자 친화적 플로우를 통해 균형 잡힌 디지털 라이프스타일을 지원합니다.

## ✨ 고민한 사항
#### 기능
- 데이터 통신: App Group(공유 컨테이너를 통한 UserDefaults 사용)을 통해 메인 앱과 DeviceActivityMonitor 간의 연결
- 핵심 기능: Family Controls (FamilyControls, DeviceActivity, ManagedSettings)를 사용하여 주요 기능 구현

#### 온보딩 플로우
- 앱이 실행될 때마다 스크린타임 권한을 확인하고, 필요 시 설정 가이드를 제공합니다.
- 처음 사용하는 사용자를 위한 도움말 화면을 제공합니다.

#### 사용자 경험 개선
- 간단한 스와이프 동작과 커스텀 알림을 결합한 안전한 삭제 기능 제공
- Auto Layout 및 신중하게 크기 조정된 버튼을 통해 소형 iPhone과의 호환성 보장

## 📦 설치 방법 
(앱 스토어 출시 준비 중)

1. 리포지토리 클론:  
   ```bash  
   git clone https://github.com/iOS05-Stargazers/STAR.git
   ```  
