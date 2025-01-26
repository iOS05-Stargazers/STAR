//
//  StarState.Style.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarState.Style

extension StarState {
    
    enum Style: CustomStringConvertible, Comparable {
        case ongoing
        case pending
        
        var description: String {
            switch self {
            case .ongoing: "진행중"
            case .pending: "대기중"
            }
        }
    }
}
