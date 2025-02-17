//
//  CustomModalTransition.swift
//  star
//
//  Created by 안준경 on 2/16/25.
//

import UIKit

// MARK: - 커스텀 모달 전환 애니메이션 정의

class CustomModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        toView.frame.origin.y = containerView.bounds.height
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: 0.3, animations: {
            toView.frame.origin.y = containerView.bounds.height - toView.frame.height
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}
