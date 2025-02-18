import UIKit
import RxSwift

final class HapticManager {
    
    enum HapticStyle {
        case impact(_ type: UIImpactFeedbackGenerator.FeedbackStyle)
        case notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
        case selection
    }
    
    static let shared = HapticManager()
    
    private init() {}
    
    private var dispose: Disposable? = nil
            
    func play(_ count: Int, style: HapticStyle) {
        // 진동 시작 시 진행중이던 진동이 있다면 메모리 해제
        dispose?.dispose()
        dispose = nil
        // 0.1초 간격으로 진동 반복
        dispose = Observable<Int>
            .timer(.seconds(0),
                   period: .milliseconds(150),
                   scheduler: MainScheduler.instance)
            .take(count)
            .map { _ in }
            .withUnretained(self)
            .subscribe(
                onNext: { owner, _ in
                owner.generateFeedback(style)
            }, onCompleted: { [weak self] in
                self?.dispose = nil
            })
    }
    
    private func generateFeedback(_ style: HapticStyle) {
        switch style {
        case .impact(let type):
            generateImpact(type)
            
        case .notification(let type):
            generateNotification(type)
            
        case .selection:
            generateSelection()
        }
    }
    
    private func generateImpact(_ type: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: type)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func generateNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    private func generateSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
