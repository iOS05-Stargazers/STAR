//
//  StarModalViewController.swift
//  star
//
//  Created by t2023-m0072 on 1/22/25.
//

import Foundation
import UIKit
import SnapKit

class StarModalViewController: UIViewController {
    
    private let modal = StarModalView()
        
    override func viewDidLoad() {
        setup()
        modal.nameTextField.delegate = self
    }
    
    private func setup() {
        view = modal
    }
}

extension StarModalViewController: UITextFieldDelegate {
    // 텍스트필드 외부 탭 했을때 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // return키 입력시 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
