import UIKit
import SnapKit
import Then
import RxSwift

final class OnboardingCollectionView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    /// 온보딩 skip 버튼
    let skipButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont.System.semibold16
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.contentHorizontalAlignment = .right
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.bounces = false
        }
        return collectionView
    }()
    
    let pageControl = UIPageControl().then {
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
        let starrySkyView = StarrySkyView()
        starrySkyView.setCloudImage(alpha: 0.1)
        
        guard let backgroundImage = starrySkyView.generateStarryBackground() else { return }
        backgroundColor = UIColor(patternImage: backgroundImage)

        addSubviews(collectionView, skipButton, pageControl)
        
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
        
        bringSubviewToFront(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = collectionView.bounds.size
        }
    }
    
    // MARK: - UI Update
    
    func scrollToItem(at page: Int) {
        guard collectionView.numberOfItems(inSection: 0) > page else { return }
        collectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func updatePageControl(_ page: Int) {
        pageControl.currentPage = page
    }
    
    func updateSkipButtonText(isLastPage: Bool) {
        skipButton.setTitle(isLastPage ? "onboarding.start_button".localized : "onboarding.skip_button".localized, for: .normal)
    }
}
