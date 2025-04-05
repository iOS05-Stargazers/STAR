//
//  FamilyActivityPickerView.swift
//  star
//
//  Created by Doyle Hwang on 4/5/25.
//

import SwiftUI
import FamilyControls

struct FamilyActivityPickerView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: FamilyActivitySelection
    @State private var tempSelection: FamilyActivitySelection
    
    init(selection: Binding<FamilyActivitySelection>) {
        self._selection = selection
        self._tempSelection = State(initialValue: selection.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("취소") {
                    dismiss()
                }
                Spacer()
                Button("저장") {
                    selection = tempSelection
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .foregroundStyle(.white)
            
            FamilyActivityPicker(selection: $tempSelection)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
