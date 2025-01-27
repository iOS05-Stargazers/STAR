//
//  MockData.swift
//  star
//
//  Created by 0-jerry on 1/26/25.
//

import Foundation

private let starID = UUID()
private let blockList = [UUID(), UUID()]

struct MockData {
    static let starTime1 = StarTime(date: .now)
    static let starTime2 = StarTime(hour: 10, minute: 10)
    static let starTime3 = StarTime(from: "10:10")
    
    static let schedule1 = Schedule(startTime: StarTime(from: "10:30"),
                                    finishTime: StarTime(from: "11:30"),
                                    weekDays: [.mon, .thu])
    static let schedule2 = Schedule(startTime: StarTime(from: "10:30"),
                                    finishTime: StarTime(from: "11:30"),
                                    weekDays: Set<WeekDay>(WeekDay.allCases))
    
    static let star1 = { Star(identifier: starID,
                              title: "Test STAR",
                              blockList: blockList,
                              schedule: schedule1) }()
    
    static let star2 = { Star(identifier: starID,
                              title: "테스트 스타",
                              blockList: blockList,
                              schedule: schedule2) }()
    
    static func printWhole() {
        let testDescription = [
            starTime1.testDescription,
            starTime2.testDescription,
            starTime3.testDescription,
            schedule1.testDescription,
            schedule2.testDescription,
            star1.testDescription,
            star2.testDescription
        ]
        
        testDescription.forEach { print($0, "\n") }
    }
}
