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

## 👥 The Team
| Name     | GitHub   | Main Developments |
|:--------:| -------- |:-----------------:|
| 박유빈 <br> Youbin Park | [@daydreamplace](https://github.com/daydreamplace) | PermissionView <br> Base for Data Manager |
| 서문가은 <br> Gaeun Seomun | [@name-mun](https://github.com/name-mun) | StarListView (MainView) <br> Star List Handling |
| 안준경 <br> Jungyung Ahn | [@AhnJunGyung](https://github.com/AhnJunGyung) | StarModalView (SecondaryView) <br> User Input Handling |
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

## 🏷 Main Features
#### Star - Your Digital Time Management Unit
- Users can create and manage multiple Stars.
- A Star functions as a single session, having a name, a list of apps to block, active times, and designated days of the week.

#### Manage Stars
- Users can view and add Stars from the Stars list.
- Existing Stars can be selected to modify their settings.

#### Switch to Break Mode
- Even while a Star is active, users can temporarily disable the Screen Time feature for up to 20 minutes.
- A user-friendly flow encourages a balanced digital lifestyle.1

## ✨ Considerations
#### Capabilities
- Data Communication: Connect the main app with the DeviceActivityMonitor through an App Group (using UserDefaults via a shared container).
- Core Functionality: Implement key features using Family Controls (FamilyControls, DeviceActivity, ManagedSettings).

#### Onboarding Flow
- Check Screen Time permissions every time the app launches and provide setup guidance if necessary.
- Offer a help screen for first-time users.

#### User Experience Improvements
- Provide an easy yet safe deletion feature that combines simple swipe actions with custom alerts.
- Ensure compatibility with small-screen iPhones through Auto Layout and thoughtfully sized buttons for enhanced usability.

## 📦 How to Install  
1. Clone this repository:  
   ```bash  
   git clone https://github.com/iOS05-Stargazers/STAR.git
   ```  
