//
//  StarListCollectionViewCell.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class StarListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI 컴포넌트
    
    static let id = "StarListCollectionViewCell"
    
    private var viewModel: StarListCollectionViewCellViewModel?
    private var disposeBag = DisposeBag()
    
    // 태그 뷰
    private let tagView = GradientView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .starDisabledTagBG
        $0.clipsToBounds = true
    }
    
    // 태그 라벨
    private let tagLabel = UILabel().then {
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
        $0.font = UIFont.System.semibold14
    }
    
    // 타이틀 라벨
    let titleLabel = UILabel().then {
        $0.textColor = .starPrimaryText
        $0.textAlignment = .left
        $0.font = UIFont.System.semibold20
    }
    
    // 시간 라벨
    private let timeLabel = UILabel().then {
        $0.textColor = .starPrimaryText
        $0.textAlignment = .right
        $0.font = UIFont.MonospacedDigitSystem.semibold14
    }
    
    // 타이머 이미지
    private let timerImageView = UIImageView().then {
        $0.image = UIImage(systemName: "alarm")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .starPrimaryText
    }
    
    // MARK: - 초기화
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - 레이아웃 설정
    
    private func setupUI() {
        layer.cornerRadius = 20
        backgroundColor = .starModalBG
        
        [
            tagView,
            titleLabel,
            timeLabel,
            timerImageView
        ].forEach {
            addSubview($0)
        }
        
        tagView.addSubview(tagLabel)
        
        tagView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.height.equalTo(32)
            $0.width.equalTo(60)
        }
        
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(24)
            $0.leading.equalTo(tagView.snp.leading)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        timerImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(88)
            $0.bottom.equalTo(timeLabel.snp.bottom)
        }
        
        tagView.applyGradient(colors: [.starButtonPurple, .starButtonNavy], direction: .horizontal)
    }
}

extension StarListCollectionViewCell {
    // 인스턴스 생성할 때 실행
    func configure(star: Star) {
        self.viewModel = StarListCollectionViewCellViewModel(star: star)
        titleLabel.text = star.title
        
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform()
        
        output.timer
            .drive(with: self, onNext: { owner, time in
                owner.timeLabel.text  = "\(time)"
            })
            .disposed(by: disposeBag)
        
        output.state
            .drive(with: self, onNext: { owner, state in
                owner.applyStateStyle(state)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func applyStateStyle(_ state: StarState.Style) {
        switch state {
        case .ongoing:
            self.tagLabel.text = "진행중"
            self.tagView.gradientLayer.isHidden = false
            self.timerImageView.isHidden = false
            
        case .pending:
            self.tagLabel.text = "대기중"
            self.tagView.gradientLayer.isHidden = true
            self.timerImageView.isHidden = true
        }
    }
}
