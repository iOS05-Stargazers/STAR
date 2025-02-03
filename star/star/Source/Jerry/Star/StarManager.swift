//
//  StarManager.swift
//  star
//
//  Created by 0-jerry on 1/30/25.
//

import Foundation

final class StarManager {
    static let shared = StarManager()
    private init() {}
//    private let coreDateManager = CoreDataManager.shared
    
//    func read() -> [Star] {
//        let starEntityList = coreDateManager.fetchAllStars()
//        let starList = starEntityList.compactMap { StarTranslator.star(from: $0) }
//        
//        return starList
//    }
//    
//    func create(_ star: Star) {
//        let starEntityForm = starEntityForm(star)
//        coreDateManager.createStar(starEntityForm: starEntityForm)
//    }
//    
//    func delete(_ star: Star) {
//        let starEntityForm = starEntityForm(star)
//        coreDateManager.deleteStar(starEntityForm)
//    }
//    
//    func update(_ star: Star) {
//        let starEntityForm = starEntityForm(star)
//        coreDateManager.updateStar(starEntityForm: starEntityForm)
//    }
//    
//    private func starEntityForm(_ star: Star) -> StarEntityForm {
//        return StarTranslator.entity(from: star)
//    }
}
