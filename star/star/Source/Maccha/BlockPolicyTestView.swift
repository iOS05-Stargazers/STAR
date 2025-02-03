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
    // Family Activity Picker 관련 상태 변수
    @State private var isPickerPresented: Bool = false
    @State private var selection: FamilyActivitySelection = FamilyActivitySelection()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Block Policy Test")
                .font(.largeTitle)
                .padding()
            
            // 버튼을 눌러 앱 선택 화면(Picker) 띄우기
            Button(action: {
                isPickerPresented = true
            }) {
                Text("차단할 앱 선택")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // 현재 선택된 앱들을 리스트로 보여주기
            if selection.applicationTokens.isEmpty {
                Text("선택된 앱이 없습니다.")
                    .foregroundColor(.secondary)
            } else {
                List(Array(selection.applications), id: \.self) { app in
                    Text(app.bundleIdentifier ?? "Unknown App")
                }
                .frame(height: 200)
            }
            
            // 선택한 앱들에 대해 차단 정책 적용 버튼
            Button(action: {
                applyBlockPolicy()
            }) {
                Text("차단 정책 적용")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        // Family Activity Picker modifier: isPresented 바인딩과 sleection 바인딩
        .familyActivityPicker(isPresented: $isPickerPresented, selection: $selection)
        // 선택 값이 바뀔 때마다 로그 출력
        .onChange(of: selection) { newSelection in
            print("선택 변경됨: \(newSelection)")
        }
    }
    
    func applyBlockPolicy() {
        guard !selection.applicationTokens.isEmpty else {
            print("차단할 앱이 선택되지 않았습니다.")
            return
        }
        
        let blockedApps: Set<ApplicationToken> = selection.applicationTokens
        let store = ManagedSettingsStore()
        store.shield.applications = blockedApps
        
        print("차단 정책이 적용되었습니다: \(blockedApps)")
    }
    
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
