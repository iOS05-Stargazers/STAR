//
//  PickerModalViewController.swift
//  star
//
//  Created by 안준경 on 2/13/25.
//

import UIKit
import RxSwift
import RxCocoa

final class TimePickerModalViewController: UIViewController {
    
    private let modalView = TimePickerModalView()
    private let viewModel: TimePickerModalViewModel
    private let disposeBag = DisposeBag()
    
    let startTimeRelay = PublishRelay<StarTime>()
    let endTimeRelay = PublishRelay<StarTime>()
    
    // picker에서 시간을 표현하기 위한 데이터
    private let hourData = Observable.just(Array(0...23))  // "0" ~ "23"
    private let minuteData = Observable.just(Array(0...59)) // "0" ~ "59"
    
    private let pickerMode: TimeType
    
    init(viewModel: TimePickerModalViewModel) {
        self.viewModel = viewModel
        self.pickerMode = viewModel.pickerMode
        super.init(nibName: nil, bundle: nil)
        bind(mode: viewModel.pickerMode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = modalView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup(mode: pickerMode)
    }
    
    private func setup(mode: TimeType) {
        
        let starTime = mode.starTime
        
        modalView.titleLabel.text = mode.text
        
        // selectRow는 데이터를 로드한 후 실행해야 하므로 DispatchQueue 사용
        self.modalView.pickerView.selectRow(starTime.hour, // 시간
                                            inComponent: 0,
                                            animated: false)
        self.modalView.pickerView.selectRow(starTime.minute, // 분
                                            inComponent: 1,
                                            animated: false)
    }
}

// MARK: - ViewModel Bind

extension TimePickerModalViewController {
    
    private func bind(mode: TimeType) {
        
        modalView.timeSelectButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.timeSelect(mode: owner.pickerMode)
            }).disposed(by: disposeBag)
        
        let input = TimePickerModalViewModel.Input(startTimeRelay: startTimeRelay.asObservable(),
                                                   endTimeRelay: endTimeRelay.asObservable())
        
        let output = viewModel.transform(input: input)
        
        // UIPickerView 데이터 바인딩
        Observable.combineLatest(output.hourData.asObservable(),
                                 output.minuteData.asObservable()) {
            ($0.map { String(format: "%02d", $0) }, // 시간 데이터 HH 형태로 변환
             $1.map { String(format: "%02d", $0) }) // 분 데이터 mm 형태로 변환
        }.bind(to: modalView.pickerView.rx.items(adapter: PickerViewAdapter()))
            .disposed(by: disposeBag)
        
    }
    
    private func timeSelect(mode: TimeType) {
        // picker에서 선택한 시간/분
        let hour = modalView.pickerView.selectedRow(inComponent: 0)
        let minute = modalView.pickerView.selectedRow(inComponent: 1)
        
        let starTime = StarTime(hour: hour, minute: minute)
        
        switch pickerMode {
        case .startTime: startTimeRelay.accept(starTime)
        case .endTime: endTimeRelay.accept(starTime)
        }
        
        dismiss(animated: true)
    }
}
