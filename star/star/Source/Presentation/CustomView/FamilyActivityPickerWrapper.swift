//
//  FamilyActivityPickerWrapper.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-05.
//

import SwiftUI
import FamilyControls

struct FamilyActivityPickerWrapper: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    @Binding var selection: FamilyActivitySelection
    
    var body: some View {
        Color.clear
            .familyActivityPicker(isPresented: $isPresented, selection: $selection)
            .onChange(of: isPresented) { newValue in
                if !newValue {
                    dismiss()
                }
            }
    }
}
