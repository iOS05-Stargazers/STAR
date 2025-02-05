//
//  MockData.swift
//  star
//
//  Created by 0-jerry on 1/26/25.
//

import Foundation

private let starID = UUID()
private let blockList = [UUID(), UUID()]
private let weekDayAllCaseSet = Set<WeekDay>(WeekDay.allCases)
private let oneDayLater = WeekDay(from: .now + ( 60 * 60 * 24 ))!
private let threeDayLater = WeekDay(from: .now + ( 60 * 60 * 24 * 3 ))!
private let oneHourBefore = Date.now - TimeInterval(3600)
private let oneHourLater = Date.now + TimeInterval(3600)
private let threeHourBefore = Date.now - TimeInterval(3600) * 3
private let threeHourLater = Date.now + TimeInterval(3600) * 3



struct MockData {
    private static let starTime1 = StarTime(date: .now)
    private static let starTime2 = StarTime(hour: 10, minute: 10)
    private static let starTime3 = StarTime(from: "10:10")
    
    private static let schedule1 = Schedule(startTime: StarTime(from: "23:58"),
                                            endTime: StarTime(from: "23:59"),
                                            weekDays: [.thu])
    private static let schedule2 = Schedule(startTime: StarTime(from: "00:00"),
                                            endTime: StarTime(from: "23:59"),
                                            weekDays: weekDayAllCaseSet)
    // 진행중 1시간 후 종료
    private static let ongoingOneHourSchedule = Schedule(startTime: StarTime(date: oneHourBefore),
                                                         endTime: StarTime(date: oneHourLater),
                                                         weekDays: weekDayAllCaseSet)
    // 진행중 3시간 후 종료
    private static let ongoingThreehourSchedule = Schedule(startTime: StarTime(date: threeHourBefore),
                                                           endTime: StarTime(date: threeHourLater),
                                                           weekDays: weekDayAllCaseSet)
    // 대기중 1분 후 시작
    private static let pendingOneMinuteSchedule = Schedule(startTime: StarTime(date: .now + 61),
                                                           endTime: StarTime(date: .now + 62),
                                                           weekDays: weekDayAllCaseSet)
    // 대기중 10분 후 시작
    private static let pendingTenMinuteSchedule = Schedule(startTime: StarTime(date: .now + 600),
                                                           endTime: StarTime(date: .now + 601),
                                                           weekDays: weekDayAllCaseSet)
    // 대기중 3시간 후 시작
    private static let pendingThreeHourSchedule = Schedule(startTime: StarTime(date: threeHourLater),
                                                           endTime: StarTime(date: threeHourLater + 1),
                                                           weekDays: weekDayAllCaseSet)
    private static let pendingOneDaySchedule = Schedule(startTime: StarTime(date: .now),
                                                        endTime: StarTime(date: .now),
                                                        weekDays: [oneDayLater])
    private static let pendingThreeDaySchedule = Schedule(startTime: StarTime(date: .now),
                                                          endTime: StarTime(date: .now),
                                                          weekDays: [threeDayLater])
    
    static let beforeUpdate = { Star(identifier: starID,
                                      title: "업데이트 전 스타",
                                     blockList: .init(),
                                      schedule: ongoingOneHourSchedule) }()
    static let afterUpdate = { Star(identifier: starID,
                                      title: "업데이트 후 스타",
                                      blockList: .init(),
                                      schedule: ongoingOneHourSchedule) }()
    
    static let ongingOneHour = { Star(identifier: UUID(),
                                      title: "진행중 1시간",
                                      blockList: .init(),
                                      schedule: ongoingOneHourSchedule) }()
    
    static let ongingThreeHour = { Star(identifier: UUID(),
                                        title: "진행중 3시간",
                                        blockList: .init(),
                                        schedule: ongoingThreehourSchedule) }()
    
    static let pendingOneMinute = { Star(identifier: UUID(),
                                         title: "대기중 1분",
                                         blockList: .init(),
                                         schedule: pendingOneMinuteSchedule)  }()
    
    static let pendingTenMinute = { Star(identifier: UUID(),
                                         title: "대기중 10분",
                                         blockList: .init(),
                                         schedule: pendingTenMinuteSchedule) }()
    
    static let pendingThreeHour = { Star(identifier: UUID(),
                                         title: "대기중 3시간",
                                         blockList: .init(),
                                         schedule: pendingThreeHourSchedule) }()
    static let pendingOneDay = { Star(identifier: UUID(),
                                      title: "대기중 1일",
                                      blockList: .init(),
                                      schedule: pendingOneDaySchedule) }()
    static let pendingThreeDay = { Star(identifier: UUID(),
                                        title: "대기중 3일",
                                        blockList: .init(),
                                        schedule: pendingThreeDaySchedule) }()
    
    static func printWhole() {
        let testDescription: [TestDescriptionConvertible] = [
            starTime1,
            starTime2,
            starTime3,
            schedule1,
            schedule2,
            ongoingOneHourSchedule,
            ongoingThreehourSchedule,
            pendingOneMinuteSchedule,
            pendingTenMinuteSchedule,
            pendingThreeHourSchedule,
            ongingOneHour,
            ongingThreeHour,
            pendingOneMinute,
            pendingTenMinute,
            pendingThreeHour,
            pendingOneDay,
            pendingThreeDay
        ]
        
        testDescription.forEach { print($0.testDescription, "\n") }
    }
    
    static let stars = [
        ongingOneHour,
        pendingTenMinute,
        pendingThreeHour,
        ongingThreeHour,
        pendingOneDay,
        pendingOneMinute,
        pendingThreeDay]
}
