////
////  PermissionViewController.swift
////  star
////
////  Created by Eden on 1/24/25.
////
//
//import UIKit
//import SnapKit
//import RxSwift
//
//final class PermissionViewController: UIViewController {
//    
//    private let permissionView = PermissionView()
//    private let permissionViewModel = PermissionViewModel()
//    private let disposeBag = DisposeBag()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        bind()
//    }
//    
//    private func setupUI() {
//        view = permissionView
//        navigationController?.navigationBar.isHidden = true
//    }
//    
//    private func bind() {
//        let input = PermissionViewModel.Input(
//            requestPermissionTrigger: Observable.just(())
//        )
//        
//        let output = permissionViewModel.transform(input)
//        
//        output.navigateToStarList
//            .drive(onNext: { [weak self] in
//                self?.navigateToStarList()
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    private func navigateToStarList() {
//        let starListViewController = StarListViewController()
//        navigationController?.pushViewController(starListViewController, animated: false)
//    }
//}
