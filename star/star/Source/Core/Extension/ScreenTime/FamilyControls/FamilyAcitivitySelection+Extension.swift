//
//  FamilyAcitivitySelection+Extension.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-11.
//

import FamilyControls

// MARK: - FamilyActivitySelection Parser

extension FamilyActivitySelection {
    // 토큰이 비어있는지 확인
    var isEmpty: Bool {
        self.applicationTokens.isEmpty &&
        self.categoryTokens.isEmpty &&
        self.webDomainTokens.isEmpty
    }
}

// 데이터 리프레쉬
extension FamilyActivitySelection {
    // FamilyActivitySelection 토큰 합 연산
    mutating func add(_ selection: FamilyActivitySelection) {
        self.applicationTokens = applicationTokens.union(selection.applicationTokens)
        self.categoryTokens = categoryTokens.union(selection.categoryTokens)
        self.webDomainTokens = webDomainTokens.union(selection.webDomainTokens)
    }
}
