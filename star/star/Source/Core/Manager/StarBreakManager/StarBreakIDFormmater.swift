//
//  StarBreakIDFormmater.swift
//  star
//
//  Created by 0-jerry on 4/10/25.
//

import Foundation

// Star 중단 ID 형식자
struct StarBreakIDFormmater {
    private static let header = "[Break]"
    
    static func key(of star: Star) -> String {
        let uuidString = star.identifier.uuidString
        let key = String(format: "%@:%@", header, uuidString)
        return key
    }
    
    // String -> UUID? 변환
    static func rawValue(_ key: String) -> String? {
        let components = key.components(separatedBy: ":")
        guard components.count == 2,
              components[0] == header,
              let rawValue = components.last else { return nil }
        
        return rawValue
    }
    
}
