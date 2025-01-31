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
    func createStar(starEntityForm: StarEntityForm) {
        let newStar = StarEntity(context: context)
        newStar.setValue(from: starEntityForm)
        
        do {
            try context.save()
            print("Star 생성")
        } catch {
            print("Star 생성 에러 \(error)")
        }
    }
    
    // 전체 Star 조회
    func fetchAllStars() -> [StarEntity] {
        let fetchRequest: NSFetchRequest<StarEntity> = StarEntity.fetchRequest()
        
        do {
            let stars = try context.fetch(fetchRequest)
            print("Star 조회: \(stars)")
            return stars
        } catch {
            print("Star 조회 에러 \(error)")
            return []
        }
    }
    
    // Star 조회
    func fetchStar(_ id: UUID) -> StarEntity? {
        let fetchRequest: NSFetchRequest<StarEntity> = StarEntity.fetchRequest()
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
    func updateStar(starEntityForm: StarEntityForm) {
        guard let starEntity = fetchStar(starEntityForm.id) else { return }
        starEntity.setValue(from: starEntityForm)
        do {
            try context.save()
            print("Star 수정")
        } catch {
            print("Star 수정 에러 \(error)")
        }
    }
    
    
    // Star 삭제
    func deleteStar(_ starEntityForm: StarEntityForm) {
        guard let star = fetchStar(starEntityForm.id) else {
            print("Star \(starEntityForm.name) 찾기 실패")
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

extension StarEntity {
    
    enum Keys {
        static let id = "id"
        static let name = "name"
        static let appList = "appList"
        static let startTime = "startTime"
        static let endTime = "endTime"
        static let repeatDays = "repeatDays"
    }
    
    func setValue(from starEntityForm: StarEntityForm) {
        self.setValue(starEntityForm.id, forKey: StarEntity.Keys.id)
        self.setValue(starEntityForm.name, forKey: StarEntity.Keys.name)
        self.setValue(starEntityForm.appList, forKey: StarEntity.Keys.appList)
        self.setValue(starEntityForm.startTime, forKey: StarEntity.Keys.startTime)
        self.setValue(starEntityForm.endTime, forKey: StarEntity.Keys.endTime)
        self.setValue(starEntityForm.repeatDays, forKey: StarEntity.Keys.repeatDays)
    }
    
}
