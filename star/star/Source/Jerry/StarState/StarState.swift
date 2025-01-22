//
//  StarState.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarState

struct StarState {
    

    var style: Style
    var distance: TimeInterval
    
    init(style: Style, distance: TimeInterval) {
        self.style = style
        self.distance = distance
    }

}

extension StarState: Comparable {
    
    static func < (lhs: StarState, rhs: StarState) -> Bool {
        guard lhs.style <= rhs.style else { return false }
        return lhs.distance < rhs.distance
    }
    
    static func == (lhs: StarState, rhs: StarState) -> Bool {
        lhs.style == rhs.style && lhs.distance == rhs.distance
    }
    
}
