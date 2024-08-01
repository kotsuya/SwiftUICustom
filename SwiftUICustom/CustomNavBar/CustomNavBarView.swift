//
//  CustomNavBarView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/20.
//

import SwiftUI

struct CustomNavBarView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        NavigationView {
            CustomNavContainerView {
                content
            }
        }
    }
}

#Preview {
    CustomNavBarView {
        Color.red.ignoresSafeArea()
    }
}
