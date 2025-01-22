//
//  StarListViewController.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit

class StarListViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    
    let starListView = StarListView()
    
    // MARK: - 생명주기 메서드
    
    override func loadView() {
        view = starListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
