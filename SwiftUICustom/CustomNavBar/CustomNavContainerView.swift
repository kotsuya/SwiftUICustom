//
//  CustomNavContainerView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/20.
//

import SwiftUI

struct CustomNavContainerView<Content: View>: View {
    
    let content: Content
    
    @State private var title: String = ""
    @State private var subtitle: String? = nil
    @State private var subtitleIcon: Image? = nil
    @State private var isHiddenBackButton: Bool = false
    @State private var isHiddenCloseButton: Bool = true
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavHeaderView(title: title, subtitle: subtitle, subtitleIcon: subtitleIcon, isHiddenBackButton: isHiddenBackButton, isHiddenCloseButton: isHiddenCloseButton)
            
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavBarTitlePreferenceKey.self, perform: { value in
            self.title = value
        })
        .onPreferenceChange(CustomNavBarSubtitlePreferenceKey.self, perform: { value in
            self.subtitle = value
        })
        .onPreferenceChange(CustomNavBarSubtitleIconPreferenceKey.self, perform: { value in
            self.subtitleIcon = value
        })
        .onPreferenceChange(CustomNavBarIsHiddenBackButtonPreferenceKey.self, perform: { value in
            self.isHiddenBackButton = value
        })
        .onPreferenceChange(CustomNavBarIsHiddenCloseButtonPreferenceKey.self, perform: { value in
            self.isHiddenCloseButton = value
        })
    }
}

#Preview {
    CustomNavContainerView {
        ZStack {
            Color.green.ignoresSafeArea()
            
            Text("Custom Nav Container View")
                .customNavBarTitle("Title")
                .customNavBarSubtitle("subtitle")
        }
    }
}
