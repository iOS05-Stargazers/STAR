//
//  DatePickerModalViewController.swift
//  star
//
//  Created by 안준경 on 2/4/25.
//

import UIKit
import SnapKit
import Then

final class DatePickerModalViewController: UIViewController {
    
    private let datePickerModalView = DatePickerModalView()
    
    override func viewDidLoad() {
        view = datePickerModalView
        setupUI()
    }
    
    private func setupUI() {
        
    }
}
