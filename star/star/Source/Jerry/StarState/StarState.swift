//
//  StarState.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarState

struct StarState {
    // 상태 ( 연산 프로퍼티 예정 )
    var style: Style
    // 남은 시간
    var distance: TimeInterval
    
    init(style: Style, distance: TimeInterval) {
        self.style = style
        self.distance = distance
    }
    
}

// 진행중, 대기중, 남은 시간에 따른 정렬을 위해 Comparable 채택
extension StarState: Comparable {
    
    static func < (lhs: StarState, rhs: StarState) -> Bool {
        guard lhs.style <= rhs.style else { return false }
        return lhs.distance < rhs.distance
    }
    
    static func == (lhs: StarState, rhs: StarState) -> Bool {
        lhs.style == rhs.style && lhs.distance == rhs.distance
    }
    
}
