//
//  FamilyActivityPickerWrapper.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-05.
//

import SwiftUI
import FamilyControls

struct FamilyActivityPickerWrapper: View {
    @Binding var isPresented: Bool
    @Binding var selection: FamilyActivitySelection
    
    var body: some View {
        Color.clear
            .familyActivityPicker(isPresented: $isPresented, selection: $selection)
    }
}
