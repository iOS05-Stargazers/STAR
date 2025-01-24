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

// MARK: - StarID

typealias StarID = UUID

// MARK: - AppID

typealias AppID = UUID
