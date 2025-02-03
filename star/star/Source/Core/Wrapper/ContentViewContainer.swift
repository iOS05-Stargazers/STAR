//
//  ContentViewContainer.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-01.
//

import SwiftUI

struct ContentViewContainer: View {
    // environmentObject로 주입받은 인스턴스를 사용합니다.
    @EnvironmentObject var familyControlsManager: FamilyControlsManager

    var body: some View {
        VStack {
            if !familyControlsManager.hasScreenTimePermissionPublished {
                // 사용자가 PermissionViewRepresentable의 아무곳이나 터치하면 권한 요청ㅇ ㅣ실행됨
                PermissionViewRepresentable()
                    .ignoresSafeArea()
                    .onTapGesture {
                        _ = familyControlsManager.requestAuthorization()
                            .subscribe(onSuccess: { granted in
                                print("Permission granted: \(granted)")
                            }, onFailure: { error in
                                print("Permission error: \(error)")
                            })
                    }
            } else {
                StarListViewControllerRepresentable()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onReceive(familyControlsManager.$hasScreenTimePermissionPublished) { newValue in
            print("권한 상태 변경: \(newValue)")
        }
    }
}
