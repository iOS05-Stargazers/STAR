//
//  ScheduleCalculator.swift
//  star
//
//  Created by 0-jerry on 1/23/25.
//

import Foundation

struct ScheduleCalculator {
    // StarState 를 위한 style, interval 반환
    static func starState(schedule: Schedule) -> (style: StarState.Style, interval: TimeInterval) {
        let stateStyle = style(schedule: schedule)
        let interval = stateStyle == .pending ? pendingInterval(schedule) : ongoingInterval(schedule)
        return (style: stateStyle, interval: interval)
    }
    // StarState.Style 연산
    private static func style(schedule: Schedule) -> StarState.Style {
        let startTime = schedule.startTime
        let endTime = schedule.endTime

        for weekDay in schedule.weekDays {
            if contains(weekDay: weekDay, startTime: startTime, endTime: endTime) {
                return .ongoing
            }
        }
        return .pending
    }
//    guard weekDay == WeekDay(from: .now) else { return false }
//    return between(start: startTime, finish: finishTime)
    // ongoing 의 경우에 대한 최소 시간차 반환
    private static func ongoingInterval(_ schedule: Schedule) -> TimeInterval {
        let intervals: [TimeInterval] = schedule.weekDays
            .compactMap {
                Self.interval(weekDay: $0, starTime: schedule.endTime) }
            .sorted(by: <)
        return intervals.first ?? 0
    }
    // pending 의 경우에 대한 최소 시간차 반환
    private static func pendingInterval(_ schedule: Schedule) -> TimeInterval {
        let intervals: [TimeInterval] = schedule.weekDays
            .compactMap {
                Self.interval(weekDay: $0, starTime: schedule.startTime) }
            .sorted(by: <)
        return intervals.first ?? 0
    }
    
    // 시간과 요일에 대해 현재 시간과의 시간차 반환
    private static func interval(weekDay: WeekDay, starTime: StarTime) -> TimeInterval? {
        guard let starDate = date(weekDay: weekDay, starTime: starTime) else { return nil }
        let interval = starDate.timeIntervalSince(.now)
        return interval
    }
    
    // 요일과 시간 범위에 대한 현재시간 포함여부 판별
    private static func contains(weekDay: WeekDay, startTime: StarTime, endTime: StarTime) -> Bool {
        guard weekDay == WeekDay(from: .now) else { return false }
        return between(start: startTime, end: endTime)
    }
    
    // 시간 범위에 대한 현재시간 포함여부 판별
    private static func between(start: StarTime, end: StarTime) -> Bool {
        let start = start.coreDataForm()
        let end = end.coreDataForm()
        let now = nowString()
        return start <= now && now < end
    }
    // 요일, 시간, 분 을 통해 Date 값 생성
    private static func date(weekDay: WeekDay, starTime: StarTime) -> Date? {
        let dateComponents = DateComponents(hour: starTime.hour,
                                            minute: starTime.minute,
                                            weekday: weekDay.rawValue)
        let date = Calendar.current.nextDate(after: .now,
                                             matching: dateComponents,
                                             matchingPolicy: .nextTime)
        return date
    }
    //
    private static func nowString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "HH:mm"
        let todayLabel = dateFormatter.string(from: Date.now)
        return todayLabel
    }
    // 시간, 분 을 통해 Date 값 생성 - 날짜는 현재 날짜
    private static func date(starTime: StarTime) -> Date? {
        let dateComponents = DateComponents(hour: starTime.hour,
                                            minute: starTime.minute)
        let date = Calendar.current.nextDate(after: .now,
                                             matching: dateComponents,
                                             matchingPolicy: .nextTime)
        return date
    }
}
