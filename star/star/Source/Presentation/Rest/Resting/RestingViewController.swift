//
//  RestingViewController.swift
//  star
//
//  Created by Eden on 2/6/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class RestingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: RestingViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "휴식중"
        $0.font = UIFont.System.semibold24
        $0.textColor = .starSecondaryText
    }
    
    private let timerLabel = UILabel().then {
        $0.font = UIFont.MonospacedDigitSystem.light80
        $0.textColor = .starSecondaryText
    }
    
    private let endRestButton = GradientButton().then {
        $0.setTitle("휴식 종료하기", for: .normal)
        $0.titleLabel?.font = UIFont.System.black16
        $0.setTitleColor(.starTertiaryText, for: .normal)
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
        $0.applyGradient(colors: [.starButtonWhite, .starButtonYellow], direction: .horizontal)
    }
    
    // MARK: - Init
    
    init(viewModel: RestingViewModel = RestingViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
    }
    
    // MARK: - Set Up
    
    private func setupUI() {
        view.backgroundColor = .starModalOverlayBG
        
        view.addSubviews(titleLabel, timerLabel, endRestButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(timerLabel.snp.top).offset(-40)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        endRestButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    // MARK: - Bind ViewModel
    
    private func bind() {
        let viewWillAppearEvent = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in } // viewWillAppear가 호출될 때마다 트리거
            .asSignal(onErrorSignalWith: .empty())
        
        let input = RestingViewModel.Input(
            startTimer: viewWillAppearEvent,
            stopTimer: endRestButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        // 타이머 값 변경 시 `timerLabel` 업데이트
        output.timerText
            .filter({ count in
                count != "00:00"
            })
            .drive(timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 타이머 0이 되면 자동으로 모달 닫기
        output.timerEnded
            .emit(with: self) { owner, _ in
                owner.closeRestingView()
            }
            .disposed(by: disposeBag)
        
        // 종료 버튼 클릭 시 모달 닫기
        endRestButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.closeRestingView()
            }
            .disposed(by: disposeBag)
        
    }
    
    // 모달 닫는 로직
    private func closeRestingView() {
        dismiss(animated: true)
    }
}

