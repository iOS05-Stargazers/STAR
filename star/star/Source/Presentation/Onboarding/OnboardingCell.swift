import UIKit
import SnapKit
import Then

final class OnboardingCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCell"
    
    // MARK: - UI Components
    
    /// 목업 이미지
    private let mockupImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    /// 하단 그라디언트  뷰
    private let gradientView = UIView()
    
    /// 스타 소개 레이블
    private let titleLabel = UILabel().then {
        $0.text = "onboarding.title".localized
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    /// 온보딩 설명 레이블
    let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubviews(
            mockupImageView,
            gradientView,
            titleLabel,
            descriptionLabel
        )
        
        mockupImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gradientView.snp.centerY)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        applyGradientBackground()
    }
    
    func configure(with model: OnboardingModel) {
        mockupImageView.image = model.image
        descriptionLabel.text = model.description
    }
    
    /// 그라데이션 배경 적용
    private func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.starDarkPurple.cgColor,
            UIColor.starAppBG.cgColor
        ]
        gradientLayer.locations = [0.0, 0.4, 0.6]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = bounds
        
        layoutIfNeeded()
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }
    }
}
