[![ko](https://img.shields.io/badge/lang-ko-blue.svg)](https://github.com/iOS05-Stargazers/STAR/blob/develop/README.md)
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/iOS05-Stargazers/STAR/blob/develop/README.en.md)

# 📱 STAR
STAR: Screen Time Awareness & Regulation (iOS App)
<br>
[https://stargazers-star.vercel.app/](https://stargazers-star.vercel.app/)

## 📚 Tech Stacks
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

## 👥 The Team
| Name     | GitHub   | Main Developments |
|:--------:| -------- |:-----------------:|
| 박유빈 <br> Youbin Park | [@daydreamplace](https://github.com/daydreamplace) | PermissionView <br> Base for Data Manager |
| 서문가은 <br> Gaeun Seomun | [@name-mun](https://github.com/name-mun) | StarListView (MainView) <br> Star List Handling |
| 안준경 <br> Jungyung Ahn | [@AhnJunGyung](https://github.com/AhnJunGyung) | StarEditView (SecondaryView) <br> User Input Handling |
| 이재영 <br> Jaeyoung Lee | [@0-jerry](https://github.com/0-jerry) | Data Model Design <br> Team Project Supervision |
| 황도일 <br> Doyle Hwang | [@DoyleHWorks](https://github.com/DoyleHWorks) | Screentime Framework <br> Common UI Components |

## ⏰ Project Scope
- **Start Date**: 2025/01/16

## 📂 Folder Organization
```bash
├── star                       // Main App of the project
│   ├── App                    // Metadata, Entitlement, Lifecycle
│   ├── Resource
│   └── Source
│        ├── Core
│        │    ├── Extension    // Extensions for DeviceActivityName, FamilyActivitySelection, UserDefaults, etc.
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
│        └── Presentation      // Views, ViewModels
│             ├── AppLaunch
│             ├── CustomView   // CustomViews, including common UI components
│             ├── Onboarding
│             ├── Permission
│             ├── Rest
│             ├── StarDeleteAlert
│             ├── StarEdit
│             └── StarListI
├── ShieldConfiguration        // App Extension for customizing the Screen Time screen that restricts app usage
├── ShieldAction               // App Extension for managing the methods invoked from the Screen Time screen that restricts app usage
└── DeviceActivityMonitor      // App Extension for managing the methods invoked according to the created Screen Time schedule
```

## 🖼️ Preview

|![Simulator Screenshot - iPhone 16 Pro Max - 2025-02-14 at 21 27 18](https://github.com/user-attachments/assets/82efbe15-dc92-4779-95ad-392bfd9be2ce)|![Simulator Screenshot - iPhone 16 Pro Max - 2025-02-14 at 21 16 32](https://github.com/user-attachments/assets/4749ca58-c445-49af-8d4e-2a52b787200c)|![Simulator Screenshot - iPhone 16 Pro Max - 2025-02-14 at 21 17 43](https://github.com/user-attachments/assets/eb80bbf8-6064-44bb-943d-63e143ad17cd)|![Simulator Screenshot - iPhone 16 Pro Max - 2025-02-14 at 21 18 21](https://github.com/user-attachments/assets/99e29c5d-ec64-4868-9f3e-f9a8be39ae61)|
|---|---|---|---|

## 🏷 Main Features
#### Star - Your Digital Time Management Unit
- Users can view, add, modify, and delete multiple Stars from the Star list.
- Each Star operates as a single session and includes a name, a list of apps to block, an active time, and designated days of the week.

#### Take a Break
- Even while a Star is active, users can temporarily disable the screen time function for up to 20 minutes.
- This feature supports a balanced digital lifestyle through a user-friendly flow.

#### User-Friendly Constraints
- A waiting screen is provided for a certain period when deleting or modifying an ongoing Star, or toggling rest mode.
- Appropriate constraints are applied to help users maintain their set goals.

#### Notifications and Haptic Feedback
- Push notifications are sent to the user 5 minutes before a Star begins, at the start, and at the end.
- The device vibrates to provide haptic feedback when a button receives user input.

## ✨ Considerations
#### Features and Architecture
- Data Communication: Connects the main app and DeviceActivityMonitor through the use of App Groups (using UserDefaults with a shared container).
- Core Functionality: Implements key features using Family Controls (FamilyControls, DeviceActivity, ManagedSettings).
- MVC → MVVM Refactoring: Initially developed using the MVC architecture, but later switched to an MVVM structure to enforce a standardized data flow and separation of responsibilities.

#### Onboarding Flow
- Upon app launch, the app checks for Screen Time permissions and provides a setup guide if necessary.
- A help screen is provided for first-time users.

#### User Experience Improvements
- Combines simple swipe gestures with custom notifications to provide a secure deletion feature.
- Guarantees compatibility with small iPhones through the use of Auto Layout.

## 🔍 Key Challenges Related to Family Controls
#### Creating and Managing Multiple Sessions
- While a single app-blocking session is relatively simple to implement, supporting multiple sessions requires leveraging the interval lifecycle methods of the ActivityDeviceMonitor App Extension.
- Separates the logic for applying the monitoring schedule of DeviceActivity and the list of apps to block in ManagedSettings (FamilyActivitySelection) for flexible management.

#### Requesting Family Controls for App Extensions
- When utilizing an App Extension, Family Controls (Distribution) permissions must be requested from Apple for each bundle ID, and approval usually takes over a month.
- Development schedules need to account for the approval waiting period for both the main app and the App Extension.

#### Limitation & Instability in FamilyActivityPicker
- FamilyActivityPicker is inherently unstable and prone to crashes, with bugs reported since 2022 that remain unresolved as of now.
- Since it is primarily supported in SwiftUI, additional handling is required to ensure it functions correctly in UIKit-based code.
- Continuous efforts are underway to improve the user experience by implementing workarounds for crash handling.

## 📦 How to Install 
<div align="left">
  <a href = "https://apps.apple.com/kr/app/%EC%8A%A4%ED%83%80-star-%EC%8A%A4%ED%81%AC%EB%A6%B0%ED%83%80%EC%9E%84-%EA%B4%80%EB%A6%AC/id6740698293?l=en-GB">
    <img  width=200  src="https://github.com/user-attachments/assets/46f5bb61-cb16-45e6-8de1-b1fed97d51a7"/>
  </a>
</div>

