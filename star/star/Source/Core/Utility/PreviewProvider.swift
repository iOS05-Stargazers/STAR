//
//  PreviewProvider.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import UIKit
import SwiftUI

// 미리보기 (SafeArea)
// 캔버스에서 프리뷰 고정핀을 설정해 다른 파일에서도 미리보기 가능
struct Preview: PreviewProvider {
    
    static var previews: some View {
        // viewController 에 할당해 사용
        let viewController = DefaultViewController()
        let root = UINavigationController(rootViewController: viewController)
        
        return root.toPreview()
    }
}

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif

@available(iOS 17.0, *)
#Preview("Preview 17.0") {
    // viewController 에 할당해 사용
    let viewController = DefaultViewController()
    let root = UINavigationController(rootViewController: viewController)
    
    return root
}
