//
//  StarState.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarState

struct StarState {
    // 상태
    let style: Style
    // 남은 시간
    let interval: TimeInterval
        
    init(schedule: Schedule) {
        let starState = ScheduleCalculator.starState(schedule: schedule)
        self.style = starState.style
        self.interval = starState.interval
    }
    
}

// 진행중, 대기중, 남은 시간에 따른 정렬을 위해 Comparable 채택
extension StarState: Comparable {
    
    static func < (lhs: StarState, rhs: StarState) -> Bool {
        guard lhs.style == rhs.style else { return
            lhs.style < rhs.style
        }
        return lhs.interval < rhs.interval
    }
    
    static func == (lhs: StarState, rhs: StarState) -> Bool {
        return lhs.style == rhs.style && lhs.interval == rhs.interval
    }
    
}
