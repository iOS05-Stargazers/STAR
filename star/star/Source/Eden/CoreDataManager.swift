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
    
    // Star 수정 ->
    /// 1. 수정이 필요할 듯 하다. ID 를 통해 해당 스타를 탐색하고 내부 데이터를 업데이트하고 저장하는 방식
    /// 2. 현재 방식은 StarEntity를 직접 모델의 데이터로 사용할때 가능한 형태
    func updateStar(star: StarEntity, name: String? = nil, appList: [String?] = [], repeatDays: [String?] = [], startTime: String? = nil, endTime: String? = nil) {
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
