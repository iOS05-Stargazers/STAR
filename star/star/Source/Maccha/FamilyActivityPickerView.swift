//
//  FamilyActivityPickerView.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-01.
//

import FamilyControls
import SwiftUI

struct FamilyActivityPickerView: View {
    @State var selection = FamilyActivitySelection()
    @State var isPresented = false

   var body: some View {
       Button("Present FamilyActivityPicker") { isPresented = true }
       .familyActivityPicker(isPresented: $isPresented,
                             selection: $selection)
       .onChange(of: selection) { newSelection in
           let applications = selection.applications
           let categories = selection.categories
           let webDomains = selection.webDomains
       }
   }
}
