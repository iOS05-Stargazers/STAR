//
//  PickerModalViewController.swift
//  star
//
//  Created by 안준경 on 2/13/25.
//

import UIKit
import RxSwift
import RxCocoa

final class PickerModalViewController: UIViewController {
    
    private let modalView = PickerModalView()
    private let viewModel: PickerModalViewModel
    private let disposeBag = DisposeBag()
    
    // picker에서 시간을 표현하기 위한 데이터
    private let hourData = Observable.just(Array(0...23))  // "0" ~ "23"
    private let minuteData = Observable.just(Array(0...59)) // "0" ~ "59"
    
    private let pickerMode: TimeType
    
    init(viewModel: PickerModalViewModel) {
        self.viewModel = viewModel
        self.pickerMode = viewModel.pickerMode
        super.init(nibName: nil, bundle: nil)
        setup(mode: viewModel.pickerMode)
        bind(mode: viewModel.pickerMode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = modalView
        pickerDataBind()
    }
    
    private func setup(mode: TimeType) {
        
        switch mode {
        case .startTime(let starTime):
            modalView.titleLabel.text = "시작 시간"
            // selectRow는 데이터를 로드한 후 실행해야 하므로 DispatchQueue 사용
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.modalView.pickerView.selectRow(starTime.hour, // 시간
                                                    inComponent: 0,
                                                    animated: false)
                self.modalView.pickerView.selectRow(starTime.minute, // 분
                                                    inComponent: 1,
                                                    animated: false)
            }
        case .endTime(let starTime):
            modalView.titleLabel.text = "종료 시간"
            // selectRow는 데이터를 로드한 후 실행해야 하므로 DispatchQueue 사용
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.modalView.pickerView.selectRow(starTime.hour, // 시간
                                                    inComponent: 0,
                                                    animated: false)
                self.modalView.pickerView.selectRow(starTime.minute, // 분
                                                    inComponent: 1,
                                                    animated: false)
            }
        }
    }
    
    private func pickerDataBind() {
        // UIPickerView에 data 연결
        let pickerData = Observable.combineLatest(hourData, minuteData) {
            // 시, 분 데이터를 HH:mm 형태로 변환
            ($0.map { String(format: "%02d", $0) },
             $1.map { String(format: "%02d", $0) })
        }
        
        pickerData
            .bind(to: modalView.pickerView.rx.items(adapter: PickerViewAdapter()))
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewModel Bind

extension PickerModalViewController {
    private func bind(mode: TimeType) {
        
        let startTimeRelay = PublishRelay<StarTime>()
        let endTimeRelay = PublishRelay<StarTime>()
        
        modalView.timeSelectButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                // picker에서 선택한 시간/분
                let hour = owner.modalView.pickerView.selectedRow(inComponent: 0)
                let minute = owner.modalView.pickerView.selectedRow(inComponent: 1)
                
                let starTime = StarTime(hour: hour, minute: minute)
                
                switch owner.pickerMode {
                case .startTime: startTimeRelay.accept(starTime)
                case .endTime: endTimeRelay.accept(starTime)
                }
                
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        let input = PickerModalViewModel.Input(startTimeRelay: startTimeRelay.asObservable(),
                                               endTimeRelay: endTimeRelay.asObservable())
        
        _ = viewModel.transform(input: input)
        
    }
}
