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
    var identifier: StarID
    var title: String
    var blockList: FamilyActivitySelection
    var schedule: Schedule
    
    func state() -> StarState {
        return StarState(schedule: self.schedule)
    }

}


extension Star: TestDescriptionConvertible {
    var testDescription: String {
        """
        <Star>
        ID: \(identifier.uuidString)
        title: \(title)
        blockList: \(blockList.rawValue)
        schedule:
        \(schedule.testDescription)
        """
    }
    
}



// MARK: - StarID

typealias StarID = UUID

// MARK: - AppID ( FamilyControl API의 앱 식별 타입에 따라 변경 예정 )

typealias AppID = UUID


// MARK: - 스케쥴을 RawRepresentable로 변환하여 AppStorage에 저장할 수 있도록 함
extension Star: RawRepresentable {
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let star = Star(from: data) else {
            return nil
        }
        self = star
    }
    
    var rawValue: String {
        guard let data = self.jsonData(),
              let string = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return string
    }
}
