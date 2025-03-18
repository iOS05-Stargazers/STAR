//
//  TodayDate.swift
//  star
//
//  Created by 서문가은 on 1/26/25.
//

import Foundation

struct TodayDate {
    
    static func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // 시스템 언어 감지
        dateFormatter.dateFormat = "star_list.date_format".localized // 다국어 지원

        return dateFormatter.string(from: date)
    }
}
