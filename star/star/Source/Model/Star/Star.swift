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
        if let breakEndTime = StarBreakManager().breakEndTime(of: self) {
            return StarState(breakEndDate: breakEndTime)
        }
        return StarState(schedule: self.schedule)
    }
}

// MARK: - StarID

typealias StarID = UUID
