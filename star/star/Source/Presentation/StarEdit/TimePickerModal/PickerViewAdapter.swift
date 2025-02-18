//
//  PickerViewAdapter.swift
//  star
//
//  Created by 안준경 on 2/14/25.
//

import UIKit
import RxSwift
import RxCocoa

final class PickerViewAdapter: NSObject, UIPickerViewDataSource, UIPickerViewDelegate, RxPickerViewDataSourceType {
    
    typealias Element = ([String], [String]) // 시간 & 분 데이터
    
    private var hourData: [String] = []
    private var minuteData: [String] = []
    
    // RxSwift에서 데이터 변경 시 호출됨
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { adapter, data in
            adapter.hourData = data.0
            adapter.minuteData = data.1
            pickerView.reloadAllComponents()
        }
        .on(observedEvent)
    }
    
    // 휠의 행 수 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // 시간, 분 2개의 컴포넌트
    }
    
    // 휠의 데이터 수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? hourData.count : minuteData.count
    }
    
    // 휠의 각 항목 표시
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(hourData[row])" : "\(minuteData[row])"
    }
}
