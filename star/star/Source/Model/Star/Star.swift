//
//  Star.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation
import FamilyControls

// MARK: - Star

struct Star: JSONCodable {
    
    let identifier: StarID
    let title: String
    let blockList: FamilyActivitySelection
    let schedule: Schedule
    
    func state() -> StarState {
        return StarState(schedule: self.schedule)
    }
}

// MARK: - StarID

typealias StarID = UUID

// MARK: - AppID ( FamilyControl API의 앱 식별 타입에 따라 변경 예정 )

typealias AppID = UUID
