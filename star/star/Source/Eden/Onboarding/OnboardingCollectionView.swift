import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class OnboardingCollectionView: UIView {
    
    private let disposeBag = DisposeBag()
    var viewModel: OnboardingViewModel?
    
    // MARK: - UI Components
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bounces = false
        }
        return collectionView
    }()
    
    private let pageControl = UIPageControl().then {
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
        addSubviews(collectionView, pageControl)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
    }
    
    // MARK: - Bind ViewModel
    
    func bind(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        
        /// 현재 페이지 변경 시 컬렉션뷰 스크롤
        viewModel.currentPage
            .asDriver()
            .distinctUntilChanged()
            .drive(with: self) { owner, page in
                owner.collectionView.scrollToItem(
                    at: IndexPath(item: page, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
                owner.pageControl.currentPage = page
            }
            .disposed(by: disposeBag)
        
        /// 페이지 컨트롤 클릭 시 해당 페이지로 이동
        pageControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let pageIndex = owner.pageControl.currentPage
                owner.viewModel?.currentPage.accept(pageIndex)
            })
            .disposed(by: disposeBag)
    }
    
}

extension OnboardingCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.pages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath) as! OnboardingCell
        guard let pageData = viewModel?.pages[indexPath.item] else { return cell }
        
        cell.descriptionLabel.text = pageData.description
        
        // TODO: - 요소 assets 추가 후 구현
        
        cell.highlightElements = pageData.highlightElements
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    // MARK: - 페이지 컨트롤과 스크롤 연동
    
    /// 사용자의 스와이프 종료 시 페이지 업데이트 (중복 방지)
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageIndex = Int(round(targetContentOffset.pointee.x / scrollView.frame.width))
        
        // 중복 호출 방지
        if viewModel?.currentPage.value != pageIndex {
            viewModel?.currentPage.accept(pageIndex)
        }
    }
}
