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
    
    private let viewModel = RestingViewModel()
    private let disposeBag = DisposeBag()
    
    private let startTimerSubject = PublishSubject<Void>()
    private let stopTimerSubject = PublishSubject<Void>()
    
    private let initialTime: Int
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "휴식중"
        $0.font = .boldSystemFont(ofSize: 32)
        $0.textColor = .starSecondaryText
    }
    
    private let timerLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.font = .monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        $0.textColor = .starSecondaryText
    }
    
    private let endRestButton = GradientButton().then {
        $0.setTitle("휴식 종료하기", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.setTitleColor(.starTertiaryText, for: .normal)
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        
        $0.applyGradient(colors: [.starButtonWhite, .starButtonYellow], direction: .horizontal)
    }
    
    // MARK: - Init
    
    init(initialTime: Int = 300) {
        self.initialTime = initialTime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        
        startTimerSubject.onNext(())
    }
    
    // MARK: - Set Up
    
    private func setupUI() {
        view.backgroundColor = .starModalOverlayBG
        
        view.addSubviews(titleLabel, timerLabel, endRestButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        endRestButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    // MARK: - Bind ViewModel
    
    private func bind() {
        let input = RestingViewModel.Input(
            startTimer: startTimerSubject.asObservable(),
            stopTimer: endRestButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, initialTime: initialTime)
        
        // 타이머 값 변경 시 `timerLabel` 업데이트
        output.timerText
            .drive(timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 종료 버튼 클릭 시 모달 닫기
        endRestButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

