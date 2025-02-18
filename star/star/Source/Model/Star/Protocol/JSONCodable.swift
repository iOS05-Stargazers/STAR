//
//  JSONCodable.swift
//  star
//
//  Created by 0-jerry on 2/4/25.
//

import Foundation

// MARK: - JSONCodable

protocol JSONCodable: JSONDecodable, JSONEncodable {}

// MARK: - JSONDecodable

protocol JSONDecodable: Decodable {}

extension JSONDecodable {
    
    init?(from data: Data) {
        guard let value = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = value
    }
}

// MARK: - JSONDecodable

protocol JSONEncodable: Encodable {}

extension JSONEncodable {
    
    func jsonData() -> Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}
