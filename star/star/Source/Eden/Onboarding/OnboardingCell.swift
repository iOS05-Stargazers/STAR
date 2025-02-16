import UIKit
import SnapKit
import Then

final class OnboardingCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCell"
    
    // MARK: - UI Components
    
    /// 목업 이미지
    private let mockupImageView = UIImageView().then {
        $0.image = UIImage(named: "appMockupSample")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    /// 강조 요소 (버튼, 아이콘 등 동적 추가)
    var highlightElements: [UIView] = []
    
    /// 그라데이션 배경 뷰
    private let gradientView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "당신의 디지털 시간 관리 단위, 스타"
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let pageControl = UIPageControl().then {
        $0.numberOfPages = 4
        $0.currentPageIndicatorTintColor = .starButtonPurple
        $0.pageIndicatorTintColor = .starPrimaryText
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
        guard let backgroundImage = UIImage(named: "backgroundImage") else { return }
        backgroundColor = UIColor(patternImage: backgroundImage)
        
        contentView.addSubviews(
            mockupImageView,
            gradientView,
            titleLabel,
            descriptionLabel,
            pageControl
        )
        
        mockupImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
        }
        
        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gradientView.snp.centerY)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(48)
        }
        
        applyGradientBackground()
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
