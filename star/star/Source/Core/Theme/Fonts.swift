//
//  Fonts.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-21.
//

import UIKit.UIFont

struct Fonts {
    
    /// 앱 메인 로고 "STAR" / size : 24 / Bold
    static let mainLogo = UIFont(name: "SEBANGGothicOTFBold", size: 24)
    /// 메인 로고 하단에 위치하는 오늘 일자 / size : 16 / semibold
    static let todayDate = UIFont.systemFont(ofSize: 16, weight: .semibold)
    /// 하단의 메인 버튼 / size : 16 / black
    static let buttonTitle = UIFont.systemFont(ofSize: 16, weight: .black)
    
    /// 스타의 이름  / size : 20 / semibold
    static let starTitle = UIFont.systemFont(ofSize: 20, weight: .semibold)
    /// 스타의 남은 시간 / size : 14 / semibold
    static let starTime = UIFont.systemFont(ofSize: 14, weight: .semibold)
    /// 스타의 태그  / size : 14 / semibold
    static let starTag = UIFont.systemFont(ofSize: 14, weight: .semibold)
    
    /// 모달의 제목  / size : 24 / semibold
    static let modalTitle = UIFont.systemFont(ofSize: 24, weight: .semibold)
    /// 모달의 부제목(설명) / size : 16 / regular
    static let modalSubtitle = UIFont.systemFont(ofSize: 16, weight: .regular)
    /// 모달의 항목별 제목 / size : 16 / semibold
    static let modalSectionTitle = UIFont.systemFont(ofSize: 16, weight: .semibold)
    /// 모달의 항목별 옵션 / size : 16 / regular
    static let modalSectionOption = UIFont.systemFont(ofSize: 16, weight: .regular)
    /// 모달의 요일 선택 옵션 / size : 16 / semibold
    static let modalDayOption = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    /// 권한 설정 화면의 제목 / size : 24 / bold
    static let permissionTitle = UIFont.systemFont(ofSize: 24, weight: .bold)
    /// 권한 설정 화면의 본문 / size : 16 / semibold
    static let permissionBody = UIFont.systemFont(ofSize: 16, weight: .semibold)
    /// 권한 설정 화면의 '더 알아보기' 버튼 / size : 16 / black
    static let permissionRedirect = UIFont.systemFont(ofSize: 16, weight: .black)
    
    /// 온보딩 튜토리얼의 본문 / size : 22 / bold
    static let tutorialDescription = UIFont.systemFont(ofSize: 22, weight: .bold)
    /// 앱 블록 화면의 본문 / size : 24 / bold
    static let blockDescription = UIFont.systemFont(ofSize: 24, weight: .bold)
}
