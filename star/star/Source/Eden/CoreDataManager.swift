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
    
    // Star 조회
    func fetchStar(_ id: UUID) -> Star? {
        let fetchRequest: NSFetchRequest<Star> = Star.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let stars = try context.fetch(fetchRequest)
            return stars.first
        } catch {
            print("\(id) Star 조회 \(error)")
            return nil
        }
    }
    
    // Star 수정
    func updateStar(star: Star, name: String? = nil, appList: [String?] = [], repeatDays: [String?] = [], startTime: String? = nil, endTime: String? = nil ) {
        if let name = name {
            star.name = name
        }
        
        if !appList.isEmpty {
            star.appList = appList.compactMap { $0 }.joined(separator: ",")
        }
        
        if !repeatDays.isEmpty {
            star.repeatDays = repeatDays.compactMap { $0 }.joined(separator: ",")
        }
        
        if let startTime = startTime {
            star.startTime = startTime
        }
        
        if let endTime = endTime {
            star.endTime = endTime
        }
        
        do {
            try context.save()
            print("Star 수정")
        } catch {
            print("Star 수정 에러 \(error)")
        }
    }
    
    // Star 삭제
    func deleteStar(_ id: UUID) {
        guard let star = fetchStar(id) else {
            print("Star \(id) 찾기 실패")
            return
        }
        
        do {
            context.delete(star)
            try context.save()
            print("Star 삭제")
        } catch  {
            print("Star 삭제 에러 \(error)")
        }
    }
}
