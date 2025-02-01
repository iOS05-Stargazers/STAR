//
//  StarTranslator.swift
//  star
//
//  Created by 0-jerry on 1/31/25.
//

import Foundation

typealias StarEntityForm = (id: UUID,
                            name: String,
                            appList: String,
                            startTime: String,
                            endTime: String,
                            repeatDays: String)


struct StarTranslator {
    // 코어데이터 저장을 위한 형식 변환
    static func entity(from star: Star) -> StarEntityForm {
        let id = star.identifier
        let title = star.title
        let appList = star.blockList.map { $0.uuidString }.joined(separator: ", ")
        let startTime = star.schedule.startTime.coreDataForm()
        let endTime = star.schedule.finishTime.coreDataForm()
        let weekDays = star.schedule.weekDays.map { String($0.rawValue) }.joined(separator: ", ")
        
        return (id: id,
                name: title,
                appList: appList,
                startTime: startTime,
                endTime: endTime,
                repeatDays: weekDays)
    }
    
    // 코어데이터 형식을 모델 형태로 변환
    static func star(from starEntity: StarEntity) -> Star? {
        guard let id = starEntity.id,
              let name = starEntity.name,
              let appList = starEntity.appList?.components(separatedBy: ", ").compactMap({ UUID(uuidString: $0) }),
              let schedule = schedule(from: starEntity) else { return nil }
        
        return Star(identifier: id,
                    title: name,
                    blockList: appList,
                    schedule: schedule)
    }
    
    // 코어데이터 형식을 통해 스케줄 데이터 타입 변환
    private static func schedule(from starEntity: StarEntity) -> Schedule? {
        guard let start = starEntity.startTime,
              let finish = starEntity.endTime,
              let weekDays = starEntity.repeatDays else { return nil }
        let weekDay = weekDays.split(separator: ", ").compactMap { Int($0) }
            .compactMap { WeekDay(rawValue: $0) }
        
        return Schedule(startTime: StarTime(from: start),
                        finishTime: StarTime(from: finish),
                        weekDays: Set<WeekDay>(weekDay))
    }
    
}
