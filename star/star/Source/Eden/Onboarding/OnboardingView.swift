//
//  OnboardingView.swift
//  star
//
//  Created by Eden on 2/13/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingView: UIView {
    
    // MARK: - UI Components
    
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "appMockupSample")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    private let collectionView = OnboardingCollectionView()
    private let bottomView = OnboardingBottomView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        guard let backgroundImage = UIImage(named: "backgroundImage") else { return }
        backgroundColor = UIColor(patternImage: backgroundImage)
        
        addSubviews(imageView, collectionView, bottomView)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.width.equalToSuperview().multipliedBy(0.6)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(440)
        }
        
        bringSubviewToFront(collectionView)
    }
}
