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
    func createStar() {
        
    }
    
    // 전체 Star 조회
    func fetchAllStars() {
        
    }
    
    // Star 수정
    func updateStar() {
        
    }
    
    // Star 삭제
    func deleteStar() {
        
    }
}
