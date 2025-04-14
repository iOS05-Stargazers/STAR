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
