//
//  PeriodPopOver.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/27.
//

import SwiftUI

struct PeriodPopOver : View {
    @State private var isShowPopover = false
    var body: some View {
        ZStack {
            Button("show popover") {
                isShowPopover = true
            }
            .popover(isPresented: $isShowPopover) {
                if #available(iOS 16.4, *) {
                    Text("Popover Content")
                        .presentationCompactAdaptation(.popover)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}

#Preview {
    PeriodPopOver()
}
