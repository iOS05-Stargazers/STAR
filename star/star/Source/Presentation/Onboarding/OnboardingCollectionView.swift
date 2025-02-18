import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class OnboardingCollectionView: UIView {
    
    private let disposeBag = DisposeBag()
    var viewModel: OnboardingViewModel?
    
    // MARK: - UI Components
    
    /// 온보딩 skip 버튼
    let skipButton = UIButton(type: .system).then {
        $0.setTitle("건너뛰기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.contentHorizontalAlignment = .right
    }
    
    private let collectionView: UICollectionView = {
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
    
    private let pageControl = UIPageControl().then {
        $0.numberOfPages = 4
        $0.currentPageIndicatorTintColor = .starButtonPurple
        $0.pageIndicatorTintColor = .starPrimaryText
    }
    
    let skipTapped = PublishRelay<Void>()
    let pageChanged = PublishRelay<Int>()
    
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
    
    // MARK: - Bind ViewModel
    
    func bind(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        
        /// 페이지 개수를 UIPageControl에 바인딩
        viewModel.pages
            .map { $0.count }
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        /// 컬렉션 뷰에 데이터 바인딩
        viewModel.pages
            .bind(to: collectionView.rx.items(cellIdentifier: OnboardingCell.identifier, cellType: OnboardingCell.self)) { _, page, cell in
                cell.configure(with: page)
            }
            .disposed(by: disposeBag)
        
        /// 사용자가 스크롤을 멈추면 현재 페이지를 감지하여 업데이트
        let pageChangedObservable = collectionView.rx.didEndDecelerating
            .map { [weak self] in
                guard let self = self else { return 0 }
                let pageIndex = Int(round(self.collectionView.contentOffset.x / self.collectionView.frame.width))
                return pageIndex
            }
            .distinctUntilChanged()
        
        /// Input: View에서 발생한 이벤트를 ViewModel로 전달
        let input = OnboardingViewModel.Input(
            skipTapped: skipButton.rx.tap.asObservable(),
            pageChanged: pageChangedObservable
        )
        
        /// Output: ViewModel에서 가공된 데이터를 View에 반영
        let output = viewModel.transform(input: input)
        
        /// 현재 페이지가 변경되면 컬렉션 뷰를 해당 페이지로 스크롤
        output.currentPage
            .withLatestFrom(viewModel.pages.asDriver(onErrorDriveWith: .empty())) { ($0, $1) }
            .drive(onNext: { [weak self] page, pages in
                guard let self = self else { return }
                
                self.collectionView.scrollToItem(
                    at: IndexPath(item: page, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
                self.pageControl.currentPage = page
                
                // 마지막 페이지에서 skipButton 문구 변경
                let isLastPage = page == pages.count - 1
                self.skipButton.setTitle(isLastPage ? "시작하기" : "건너뛰기", for: .normal)
            })
            .disposed(by: disposeBag)
        
        /// 사용자가 스크롤하면 현재 페이지를 감지하여 Relay에 전달
        pageChangedObservable
            .bind(to: pageChanged)
            .disposed(by: disposeBag)
    }
}
