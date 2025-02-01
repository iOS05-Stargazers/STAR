//
//  BlockPolicyTestView.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-01.
//

import Foundation
import ManagedSettings
import FamilyControls
import SwiftUI

struct BlockPolicyTestView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Block Policy Test")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                applyBlockPolicy()
            }) {
                Text("앱 차단 정책 적용")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Button(action: {
                removeBlockPolicy()
            }) {
                Text("앱 차단 정책 해제")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    /// 앱 번들 식별자를 사용해 해당 앱에 대해 차단 정책을 적용하는 함수
    func applyBlockPolicy() {
        // 앱의 번들 식별자 가져오기
        guard let bundleID = Bundle.main.bundleIdentifier else {
            print("번들 식별자 없음")
            return
        }
        
        // Application 인스턴스를 생성합니다.
        let app = Application(bundleIdentifier: bundleID)
        
        // 해당 앱에 대한 토큰을 가져옵니다.
        guard let appToken = app.token else {
            print("토큰을 가져올 수 없습니다. 앱 토큰이 nil입니다.")
            return
        }
        
        // 차단할 앱 집합에 토큰 추가
        let blockedApps: Set<ApplicationToken> = [appToken]
        let store = ManagedSettingsStore()
        store.shield.applications = blockedApps
        
        print("차단 정책이 적용되었습니다: \(blockedApps)")
    }

    /// 차단 정책을 해제하는 함수
    func removeBlockPolicy() {
        let store = ManagedSettingsStore()
        store.shield.applications = []
        
        print("차단 정책이 해제되었습니다.")
    }
}

struct BlockPolicyTestView_Previews: PreviewProvider {
    static var previews: some View {
        BlockPolicyTestView()
    }
}
