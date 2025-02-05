//
//  PermissionViewRepresentable.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-01.
//

import SwiftUI

struct PermissionViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> PermissionView {
        // PermissionView는 UIView이므로, 초기 프레임은 .zero로 설정하거나 적절히 지정할 것
        return PermissionView(frame: .zero)
    }
    
    func updateUIView(_ uiView: PermissionView, context: Context) {
        // 업데이트할 내용이 있다면 구현
    }
    
}
