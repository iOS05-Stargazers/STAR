//
//  Star.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - Star

struct Star {
    let identifier: StarID
    let title: String
    let blockList: [AppID]
    let schedule: Schedule
}

extension Star: TestDescriptionConvertible {
    var testDescription: String {
        
return """
[Star]
ID: \(identifier.uuidString)
title: \(title)
blockList: \(blockList.map { $0.uuidString })
schedule:
\(schedule.testDescription)
"""
}
    
}

// MARK: - StarID

typealias StarID = UUID

// MARK: - AppID

typealias AppID = UUID
