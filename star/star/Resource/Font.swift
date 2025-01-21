//
//  Font.swift
//  star
//
//  Created by 0-jerry on 1/21/25.
//

import UIKit.UIFont

struct Font {
    enum Black {
         /// - 메인 버튼 (스타 추가하기, 생성하기, 저장하기)
         /// - 권한 요청 화면 안내 문구(위, 아래), 더 알아보기
        static let sf16 = UIFont.systemFont(ofSize: 16, weight: .black)
        /// - 권한 요청 화면 - 타이틀
        /// - 잠금 화면 - 독려문구 / 스타리스트 타이틀
        static let sf24 = UIFont.systemFont(ofSize: 24, weight: .black)
    }
    enum Bold {
        /// - 잠금 화면 - 완료까지 남은 시간
        static let sf14 = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    enum Semibold {
        /// - 메인화면 - 스타 상태 태그 라벨 ( 진행중 / 대기중 ), 스타 남은 시간
        static let sf14 = UIFont.systemFont(ofSize: 14, weight: .semibold)
        /// - 메인화면 - 날짜
        /// - 스타 생성 / 수정 화면 - (타이틀) [이름, 앱 잠금, 반복 주기, 시작 시간, 종료시간]
        /// - 스타 생성 / 수정 화면 - 요일 글자, 시작 시간(값), 종료 시간(값)
        static let sf16 = UIFont.systemFont(ofSize: 16, weight: .semibold)
        /// - 메인화면 - 스타 타이틀
        /// - 잠금화면 - 스타 타이틀
        static let sf20 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        /// - 온보딩 화면 - 안내문구
        static let sf22 = UIFont.systemFont(ofSize: 22, weight: .semibold)
        /// - 스타 생성 / 수정 모달 - 타이틀 (스타 생성 / 스타 수정)
        static let sf24 = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }
    enum Regular {
        /// - 스타 생성 / 수정 모달 - [스타 이름 텍스트필드, 앱 잠금 리스트 라벨]
        static let sf14 = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    enum Light {
        /// - 스타 생성 / 수정 모달 - 안내 라벨
        static let sf16 = UIFont.systemFont(ofSize: 16, weight: .light)
    }
}
