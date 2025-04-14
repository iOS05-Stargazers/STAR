//
//  Calendar.Component+Extension.swift
//  star
//
//  Created by 0-jerry on 4/10/25.
//

import Foundation

extension Calendar.Component {
    static let forRawDate: Set<Calendar.Component> = [
        .year,
        .month,
        .day,
        .hour,
        .minute,
        .second,
        .nanosecond
    ]
}
