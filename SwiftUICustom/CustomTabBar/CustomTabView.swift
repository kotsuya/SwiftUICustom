//
//  CustomTabView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/14.
//

import SwiftUI

struct CustomTabView<Content: View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabContainerView(tabs: tabs, selection: $selection, localSelection: selection)
        }
        .onPreferenceChange(TabBarItemPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

#Preview {
    CustomTabView(selection: .constant(.home), content: {
        Color.red
    })
}
