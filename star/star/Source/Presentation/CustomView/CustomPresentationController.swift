//
//  CustomPresentationController.swift
//  star
//
//  Created by 안준경 on 2/13/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CustomPresentationController: UIPresentationController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private let behindView = UIView().then { // 모달 뒷배경
        $0.alpha = 0
        $0.backgroundColor = .starAppBG.withAlphaComponent(0.5)
    }
    
    private let grabberView = CustomGrabberView()
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: - Initializer
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupGrabber()
        setupPanGesture()
        panGestureBind()
    }
    
    private func setupGrabber() {
        guard let view = presentedView else { return }
        view.addSubview(grabberView)
        
        grabberView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.top).inset(8)
        }
    }
}

// MARK: - 모달 제어 메서드

extension CustomPresentationController {
    
    // 모달 드래그 동작 설정
    private func setupPanGesture() {
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer) // 모달 뷰에 제스처 추가
    }
    
    // panGestureRecognizer bind
    private func panGestureBind() {
        panGestureRecognizer.rx.event
            .asDriver()
            .drive(with: self, onNext: { owner, gesture in
                owner.handlePanGesture(gesture)
            }).disposed(by: disposeBag)
    }
    
    // 드래그 감지 및 동작
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: presentedView) // 드래그 수치
        let progress = translation.y / (containerView?.bounds.height ?? 1) // 화면 대비 드래그 비율 (0~1)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                presentedView?.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if progress > 0.3 { // 30% 이상 내리면 dismiss
                presentedViewController.dismiss(animated: true)
            } else { // 30% 미만이면 뷰를 원래 위치로
                UIView.animate(withDuration: 0.3) {
                    self.presentedView?.transform = .identity
                }
            }
        default: break
        }
    }
    
    // 모달이 나타날 때
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else { return }
        behindView.frame = containerView.bounds
        containerView.insertSubview(behindView, at: 0) // insertSubview : 뷰를 뒤로 보낼때 사용
        
        // 배경 효과 적용
        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.behindView.alpha = 1
            })
        } else {
            behindView.alpha = 1
        }
    }
    
    // 모달이 사라질 때
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        // 배경 효과 제거
        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.behindView.alpha = 0
            })
        } else {
            behindView.alpha = 0
        }
    }
    
    // 모달 크기 지정
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        // 모달 기본 높이
        var height: CGFloat = 610
        
        // safeArea의 최상단 Y좌표
        let safeAreaCheck = containerView.safeAreaLayoutGuide.layoutFrame.minY
        
        // iPhone SE
        if safeAreaCheck <= 20 {
            height = 560
        }
        
        return CGRect(x: 0,
                      y: containerView.bounds.height - height,
                      width: containerView.bounds.width,
                      height: height)
    }
}
