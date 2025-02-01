//
//  StarListViewControllerRepresentable.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-01.
//

import SwiftUI

struct StarListViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> StarListViewController {
        return StarListViewController()
    }
    
    func updateUIViewController(_ uiViewController: StarListViewController, context: Context) {
        // SwiftUI 상태가 변경되어 업데이트가 필요할 경우 여기에 코드를 작성할 것
        // 현재 특별한 업데이트 로직이 없다면 빈 구현으로 두어도 괜찮음
    }
}
