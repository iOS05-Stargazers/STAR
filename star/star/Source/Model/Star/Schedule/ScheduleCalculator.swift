//
//  ScheduleCalculator.swift
//  star
//
//  Created by 0-jerry on 1/23/25.
//

import Foundation

struct ScheduleCalculator {
    // StarState 를 위한 style, interval 반환
    func starState(schedule: Schedule) -> (style: StarState.Style, interval: TimeInterval) {
        let stateStyle = style(schedule: schedule)
        let interval = stateStyle == .pending ? pendingInterval(schedule) : ongoingInterval(schedule)
        return (style: stateStyle, interval: interval)
    }
    // StarState.Style 연산
    private func style(schedule: Schedule) -> StarState.Style {
        let startTime = schedule.startTime
        let endTime = schedule.endTime

        for weekDay in schedule.weekDays {
            if contains(weekDay: weekDay, startTime: startTime, endTime: endTime) {
                return .ongoing
            }
        }
        return .pending
    }
    // ongoing 의 경우에 대한 최소 시간차 반환
    private func ongoingInterval(_ schedule: Schedule) -> TimeInterval {
        let intervals: [TimeInterval] = schedule.weekDays
            .compactMap {
                interval(weekDay: $0, starTime: schedule.endTime) }
            .sorted(by: <)
        return intervals.first ?? 0
    }
    // pending 의 경우에 대한 최소 시간차 반환
    private func pendingInterval(_ schedule: Schedule) -> TimeInterval {
        let intervals: [TimeInterval] = schedule.weekDays
            .compactMap {
                interval(weekDay: $0, starTime: schedule.startTime) }
            .sorted(by: <)
        return intervals.first ?? 0
    }
    
    // 시간과 요일에 대해 현재 시간과의 시간차 반환
    private func interval(weekDay: WeekDay, starTime: StarTime) -> TimeInterval? {
        guard let starDate = date(weekDay: weekDay, starTime: starTime) else { return nil }
        let interval = starDate.timeIntervalSince(.now)
        return interval
    }
    
    // 요일과 시간 범위에 대한 현재시간 포함여부 판별
    private func contains(weekDay: WeekDay, startTime: StarTime, endTime: StarTime) -> Bool {
        if startTime < endTime {
            guard weekDay == WeekDay(from: .now) else { return false }
            return between(start: startTime, end: endTime)
        } else {
            let nextWeekDayRawValue = weekDay.rawValue == 7 ? 1 : weekDay.rawValue + 1
            guard let startDate = previousDate(from: DateComponents(hour: startTime.hour,
                                                                    minute: startTime.minute,
                                                                    weekday: weekDay.rawValue)),
                  let endDate = Calendar.current.nextDate(after: startDate,
                                                          matching: .init(hour: endTime.hour,
                                                                          minute: endTime.minute,
                                                                          weekday: nextWeekDayRawValue),
                                                          matchingPolicy: .nextTime) else { return false }
            
            let now = Date.now
            return startDate < now && now < endDate
        }
    }
    
    // 시간 범위에 대한 현재시간 포함여부 판별
    private func between(start: StarTime, end: StarTime) -> Bool {
        let now = StarTime(date: .now)
        return start <= now && now < end
    }
    
    // 요일, 시간, 분 을 통해 Date 값 생성
    private func date(weekDay: WeekDay, starTime: StarTime) -> Date? {
        let dateComponents = DateComponents(hour: starTime.hour,
                                            minute: starTime.minute,
                                            weekday: weekDay.rawValue)
        let date = Calendar.current.nextDate(after: .now,
                                             matching: dateComponents,
                                             matchingPolicy: .nextTime)
        return date
    }
    //
    private func nowString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "HH:mm"
        let todayLabel = dateFormatter.string(from: Date.now)
        return todayLabel
    }
    // 시간, 분 을 통해 Date 값 생성 - 날짜는 현재 날짜
    private func date(starTime: StarTime) -> Date? {
        let dateComponents = DateComponents(hour: starTime.hour,
                                            minute: starTime.minute)
        let date = Calendar.current.nextDate(after: .now,
                                             matching: dateComponents,
                                             matchingPolicy: .nextTime)
        return date
    }
    
    private func nowWeekdayForm() -> String? {
        let dateComponents = Calendar.current.dateComponents([.weekday], from: .now)
        guard let weekday = dateComponents.weekday else { return nil }
        return "\(weekday):" + nowString()
    }
    
    private func previousDate(from components: DateComponents) -> Date? {
        let calendar = Calendar.current
        
        // 필수값 확인
        guard let weekday = components.weekday,
              let hour = components.hour,
              let minute = components.minute else {
            return nil
        }
        
        // 검색용 DateComponents 생성
        var searchComponents = DateComponents()
        searchComponents.weekday = weekday
        searchComponents.hour = hour
        searchComponents.minute = minute
        searchComponents.second = 0
        
        // 이전 날짜를 찾기 위한 변수
        var previousDate: Date? = nil
        
        // 현재 시간부터 거꾸로 탐색하여 첫 번째로 일치하는 날짜 찾기
        calendar.enumerateDates(
            startingAfter: Date(),
            matching: searchComponents,
            matchingPolicy: .nextTime,
            direction: .backward
        ) { date, exactMatch, stop in
            if let date = date {
                previousDate = date
                stop = true  // 첫 번째 일치하는 날짜를 찾으면 중지
            }
        }
        
        return previousDate
    }
}
