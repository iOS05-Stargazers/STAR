//
//  StarTranslator.swift
//  star
//
//  Created by 0-jerry on 1/31/25.
//

import Foundation
import FamilyControls

// MARK: - Date Extensions for UserDefaults Conversion
// (이전 코어데이터 관련 함수명을 그대로 사용하고 있으나, UserDefaults 저장 목적으로 사용)
extension Date {
    /// Date를 "HH:mm" 형식의 문자열로 변환 (UserDefaults 저장용)
    func coreDataForm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    /// "HH:mm" 형식의 문자열을 Date로 변환
    init?(coreDataForm: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: coreDataForm) else { return nil }
        self = date
    }
}

// MARK: - StarUserDefaultsForm TypeAlias
/// UserDefaults에 저장할 때 사용하는 Star의 표현 형식 (튜플 형태)
typealias StarUserDefaultsForm = (id: StarID,
                                  name: String,
                                  appLock: String,
                                  startTime: String,
                                  endTime: String,
                                  repeatDays: String)

// MARK: - StarTranslator
struct StarTranslator {
    
    /// Star 모델을 UserDefaults 저장용 형식으로 변환
    static func entity(from star: Star) -> StarUserDefaultsForm {
        let id = star.identifier
        // Schedule의 name 프로퍼티 (스타 이름)
        let name = star.schedule.name
        // appLock은 FamilyActivitySelection이 RawRepresentable이므로 rawValue 사용
        let appLock = star.schedule.appLock.rawValue
        // Date를 "HH:mm" 문자열로 변환
        let startTime = star.schedule.startTime.coreDataForm()
        let endTime = star.schedule.endTime.coreDataForm()
        // 요일은 Set<WeekDay>의 rawValue들을 정렬한 후 콤마로 구분한 문자열로 변환
        let repeatDays = star.schedule.weekDays
            .sorted(by: <)
            .map { String($0.rawValue) }
            .joined(separator: ", ")
        
        return (id: id,
                name: name,
                appLock: appLock,
                startTime: startTime,
                endTime: endTime,
                repeatDays: repeatDays)
    }
    
    /// UserDefaults 저장용 형식(StarUserDefaultsForm)에서 Star 모델로 복원
    static func star(from form: StarUserDefaultsForm) -> Star? {
        let id = form.id
        let name = form.name
        let appLockString = form.appLock
        // FamilyActivitySelection을 복원 (문자열을 통해)
        guard let appLock = FamilyActivitySelection(rawValue: appLockString) else { return nil }
        // "HH:mm" 문자열을 Date로 변환
        // FIXME: - 간이 데이터
        let startTime = StarTime(hour: 10, minute: 10)
              let endTime = StarTime(hour: 10, minute: 30)
        // repeatDays 문자열 (예: "1, 2, 3")을 파싱하여 WeekDay Set으로 변환
        let dayStrings = form.repeatDays.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        let weekDayInts = dayStrings.compactMap { Int($0) }
        let weekDays = Set(weekDayInts.compactMap { WeekDay(rawValue: $0) })
        
        // Schedule 생성
        let schedule = Schedule(name: name,
                                appLock: appLock,
                                weekDays: weekDays,
                                startTime: startTime,
                                endTime: endTime)
        // Star 생성
        return Star(identifier: id, schedule: schedule)
    }
}
