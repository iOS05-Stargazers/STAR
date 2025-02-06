//
//  Star.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - Star

struct Star: JSONCodable {
    let identifier: StarID
    let schedule: Schedule
    
    func state() -> StarState {
        return StarState(schedule: self.schedule)
    }

}


extension Star: TestDescriptionConvertible {
    var testDescription: String {
        """
        <Star>
        ID: \(identifier.uuidString)
        schedule:
        \(schedule.testDescription)
        """
    }
    
}



// MARK: - StarID

typealias StarID = UUID

// MARK: - AppID ( FamilyControl API의 앱 식별 타입에 따라 변경 예정 )

typealias AppID = UUID
