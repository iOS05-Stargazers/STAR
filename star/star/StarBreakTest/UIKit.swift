//
//  UIKit.swift
//  star
//
//  Created by 0-jerry on 4/14/25.
//

import UIKit

// FIXME: - 해당 파일의 코드는 테스트용으로 작성돼, 기능을 모두 구현된 뒤에는 삭제해주시기 바랍니다.

// FIXME: - 중단 테스트용 버튼 추가
extension StarListViewController {
    
    func testStarBreak() {
        let button = UIButton(type: .system).then {
            $0.setTitle("중단테스트", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = UIFont.System.bold16
            $0.backgroundColor = .red
            $0.layer.cornerRadius = 28
        }
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(starListView.addStarButton.snp.top).offset(-30)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                StarBreakManager().test()
                owner.viewModel.testFetchStars()

            }).disposed(by: disposeBag)
        
    }
}

