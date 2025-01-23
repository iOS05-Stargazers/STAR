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
    }
    
    private func setup() {
        view = modal
    }
}
