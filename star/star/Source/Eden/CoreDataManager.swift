//
//  CoreDataManager.swift
//  star
//
//  Created by Eden on 1/22/25.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // Star 생성
    func createStar(name: String, appList: [String], repeatDays: [String], startTime: String, endTime: String) {
        let newStar = Star(context: context)
        newStar.id = UUID()
        newStar.name = name
        newStar.appList = appList.joined(separator: ",")
        newStar.repeatDays = repeatDays.joined(separator: ",")
        newStar.startTime = startTime
        newStar.endTime = endTime
        do {
            try context.save()
            print("Star 생성")
        } catch {
            print("Star 생성 에러 \(error)")
        }
    }
    
    // 전체 Star 조회
    func fetchAllStars() {
        let fetchRequest: NSFetchRequest<Star> = Star.fetchRequest()
        
        do {
            let stars = try context.fetch(fetchRequest)
            print("Star 조회: \(stars)")
        } catch {
            print("Star 조회 에러 \(error)")
        }
    }
    
    // Star 수정
    func updateStar() {
        
    }
    
    // Star 삭제
    func deleteStar() {
        
    }
}
