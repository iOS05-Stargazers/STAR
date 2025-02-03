//
//  ScheduleVM.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-03.
//

import Foundation
import FamilyControls
import SwiftUI

enum ScheduleSectionInfo {
    case time
    case apps
    case monitoring
    case revoke
    
    var header: String {
        switch self {
        case .time:
            return "setup Time"
        case .apps:
            return "setup Apps"
        case .monitoring:
            return "stop Schedule Monitoring"
        case .revoke:
            return "Revoke Authorization"
        }
    }
    
    var footer: String {
        switch self {
        case .time:
            return "시작 시간과 종료 시간을 설정하여 앱 사용을 제한하고자 하는\n스케쥴 시간을 설정할 수 있습니다."
        case .apps:
            return "변경하기 버튼을 눌러 선택한 시간 동안 사용을 제한하고 싶은\n앱 및 웹 도메인을 선택할 수 있습니다."
        case .monitoring:
            return "현재 모니터링 중인 스케줄의 모니터링을 중단합니다."
        case .revoke:
            return ""
        }
    }
}

// MARK: - 요일 Enum (요일 선택용)
enum Weekday: Int, Codable, CaseIterable, Identifiable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var id: Int { rawValue }
    
    // 필요에 따라 한글 약칭 등을 제공할 수도 있습니다.
    var shortName: String {
        switch self {
        case .monday:    return "월"
        case .tuesday:   return "화"
        case .wednesday: return "수"
        case .thursday:  return "목"
        case .friday:    return "금"
        case .saturday:  return "토"
        case .sunday:    return "일"
        }
    }
}

// MARK: - 스케쥴 모델 (이름, 앱 잠금, 요일, 시작/종료 시간)
struct StarSchedule: Codable {
    var name: String = ""
    var appLock: FamilyActivitySelection = FamilyActivitySelection()
    var selectedDays: [Weekday] = [] // 선택된 요일들
    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(900) // 기본: 현재 시간 + 15분
}

// MARK: - 스케쥴을 RawRepresentable로 변환하여 AppStorage에 저장할 수 있도록 함
extension StarSchedule: RawRepresentable {
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let schedule = try? JSONDecoder().decode(StarSchedule.self, from: data)
        else {
            return nil
        }
        self = schedule
    }
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let string = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return string
    }
}


final class ScheduleVM: ObservableObject {
    // 전체 스케쥴을 하나의 AppStorage 키에 저장 (앱 그룹 UserDefaults 사용)
    @AppStorage("schedule", store: UserDefaults(suiteName: Bundle.main.appGroupName))
    var schedule: StarSchedule = StarSchedule()

    @Published var isFamilyActivitySectionActive = false
    @Published var isSaveAlertActive = false
    @Published var isRevokeAlertActive = false
    @Published var isStopMonitoringAlertActive = false
    
    private func resetAppGroupData() {
        schedule = StarSchedule()
    }
}

// MARK: - ScheduleVM의 액션 및 업데이트 메서드들
extension ScheduleVM {
    
    // MARK: 각 입력값을 업데이트하는 메서드
    func updateName(_ name: String) {
        schedule.name = name
    }
    
    func updateAppLock(_ appLock: FamilyActivitySelection) {
        schedule.appLock = appLock
    }
    
    func updateSelectedDays(_ days: [Weekday]) {
        schedule.selectedDays = days
    }
    
    func updateStartTime(_ startTime: Date) {
        schedule.startTime = startTime
    }
    
    func updateEndTime(_ endTime: Date) {
        schedule.endTime = endTime
    }
    
    // MARK: FamilyActivity Sheet 열기
    /// 호출 시 사용자가 제한하고자 하는 기기에 설치한 앱 혹은 웹 도메인을 선택할 수 있는 FamilyActivitySelection 화면 표시
    func showFamilyActivitySelection() {
        isFamilyActivitySectionActive = true
    }
    
    // MARK: 스케쥴 저장
    /// 현재 설정한 스케쥴 정보를  DeviceActivityManager에 전달하여 모니터링을 시작
    func saveSchedule() {
        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: schedule.startTime)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: schedule.endTime)
        
        DeviceActivityManager.shared.handleStartDeviceActivityMonitoring(
            startTime: startComponents,
            endTime: endComponents
        )
    }
    
}

// MARK: - FamilyActivitySelection Parser (AppStorage 저장을 위한 RawRepresentable 확장)
extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

// MARK: - Date Parser (AppStorage 저장을 위한 RawRepresentable 확장)
extension Date: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Date.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
