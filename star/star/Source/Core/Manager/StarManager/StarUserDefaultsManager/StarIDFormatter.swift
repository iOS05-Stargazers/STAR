//
//  StarIDFormatter.swift
//  star
//
//  Created by 0-jerry on 2/4/25.
//

import Foundation

struct StarIDFormatter {
    // Star ID 용 식별 헤더
    private static let header = "[STAR]"

    // UUID -> key(String) 변환
    static func key(_ id: UUID) -> String {
        let uuidString = id.uuidString
        let key = String(format: "%@:%@", header, uuidString)
        return key
    }
    // String -> UUID? 변환
    static func uuid(_ key: String) -> UUID? {
        let components = key.components(separatedBy: ":")
        guard components.count == 2,
              components[0] == header,
              let uuid = UUID(uuidString: components[1]) else { return nil }
        
        return uuid
    }
}


