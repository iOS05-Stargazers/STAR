//
//  SharedCoreDataManager.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-31.
//

import CoreData
import UIKit
import RxSwift

final class SharedCoreDataManager {
    static let shared = SharedCoreDataManager()
    private init() {}
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private let starUpdateSubject = PublishSubject<[StarEntity]>()
    
    private let disposeBag = DisposeBag()
    
    // Star 상태 변경 이벤트
    var starUpdates: Observable<[StarEntity]> {
        return starUpdateSubject.asObservable()
    }
    
    // Core Data에서 Star 데이터를 가져와 최신 상태 전달
    func fetchStars() {
        let fetchRequest: NSFetchRequest<StarEntity> = StarEntity.fetchRequest()
        
        do {
            let stars = try context.fetch(fetchRequest)
            starUpdateSubject.onNext(stars)
        } catch {
            print("Core Data 조회 에러: \(error)")
        }
    }
    
    func observeChanges() {
        // Core Data 변경 감지
        NotificationCenter.default.rx
            .notification(.NSManagedObjectContextDidSave, object: context)
            .subscribe(onNext: { [weak self] _ in
                self?.fetchStars()
            })
            .disposed(by: disposeBag)
        
        // 주기적으로 Star의 상태 변경 체크 (60초마다 실행)
        /// 메모: 리팩토링을 통해 성능 향상할 수 있을 것 같음
        Observable<Int>.interval(.seconds(60), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.checkStarStatus()
            })
            .disposed(by: disposeBag)
    }
    
    private checkStarStatus() {
        let stars = fetchAllStars()
        let activeStars = stars.filter { isStarActive($0) }
        
        print("현재 활성 Star 개수: \(activeStars.count)")
        starUpdateSubject.onNext(stars)
    }
    
    private func isStarActive(_ star: StarEntity) -> Bool {
        guard let startTime = star.startTime, let endTime = star.endTime else { return false }
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else { return false }
        
        return now >= start && now <= end
    }
    
    // 전체 Star 조회 (읽기 전용)
    func fetchAllStars() -> [StarEntity] {
        let fetchRequest: NSFetchRequest<StarEntity> = StarEntity.fetchRequest()
        
        do {
            let stars = try context.fetch(fetchRequest)
            print("공유 CoreData에서 Star 조회: \(stars)")
            return stars
        } catch {
            print("공유 CoreData 조회 에러: \(error)")
            return []
        }
    }
    
    // 특정 Star 조회 (읽기 전용)
    func fetchStar(_ id: UUID) -> StarEntity? {
        let fetchRequest: NSFetchRequest<StarEntity> = StarEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let stars = try context.fetch(fetchRequest)
            return stars.first
        } catch {
            print("공유 CoreData에서 \(id) Star 조회 실패: \(error)")
            return nil
        }
    }
}
