//
//  CustomGrabber.swift
//  star
//
//  Created by 안준경 on 2/13/25.
//

import UIKit
import SnapKit
import Then

final class CustomGrabberView: UIView {
    
    private let grabberView: UIView = { // 모달 손잡이
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        view.layer.cornerRadius = 3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(grabberView)
        
        grabberView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(6)
        }
    }
}
