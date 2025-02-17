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
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyy년 M월 dd일 (E)"
        
        return dateFormatter.string(from: date)
    }
}
