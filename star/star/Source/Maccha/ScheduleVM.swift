//
//  ScheduleVM.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-03.
//

import Foundation
import FamilyControls
import SwiftUI

final class ScheduleVM: ObservableObject {
    // 전체 스케쥴을 하나의 AppStorage 키에 저장 (앱 그룹 UserDefaults 사용)
    @AppStorage("star", store: UserDefaults(suiteName: Bundle.main.appGroupName))
    // FIXME: - 간이 데이터
    var star: Star = MockData.pendingOneDay
    @Published var isFamilyActivitySectionActive = false
    
    private func resetAppGroupData() {
        // FIXME: - 간이 데이터
        star = MockData.pendingOneDay
    }
}

// MARK: - ScheduleVM의 액션 및 업데이트 메서드들
extension ScheduleVM {
    
    // MARK: 각 입력값을 업데이트하는 메서드
    func updateName(_ name: String) {
        star.title = name
    }
    
    func updateAppLock(_ appLock: FamilyActivitySelection) {
        star.blockList = appLock
    }
    
    func updateSelectedDays(_ days: Set<WeekDay>) {
        star.schedule.weekDays = days
    }
    
    func updateStartTime(_ startTime: StarTime) {
        star.schedule.startTime = startTime
    }
    
    func updateEndTime(_ endTime: StarTime) {
        star.schedule.endTime = endTime
    }
    
    // MARK: FamilyActivity Sheet 열기
    /// 호출 시 사용자가 제한하고자 하는 기기에 설치한 앱 혹은 웹 도메인을 선택할 수 있는 FamilyActivitySelection 화면 표시
    func showFamilyActivitySelection() {
        isFamilyActivitySectionActive = true
    }
    
    // MARK: 스케쥴 저장
    /// 현재 설정한 스케쥴 정보를  DeviceActivityManager에 전달하여 모니터링을 시작
    func saveSchedule() {
        let startTimeHour = star.schedule.startTime.hour
        let startTimeMinute = star.schedule.startTime.minute
        let endTimeHour = star.schedule.endTime.hour
        let endTimeMinute = star.schedule.endTime.minute
        
        let startComponents = DateComponents(hour: startTimeHour, minute: startTimeMinute)
        let endComponents = DateComponents(hour: endTimeHour, minute: endTimeMinute)
        
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
