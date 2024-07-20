//
//  AppTabBarView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/14.
//

import SwiftUI

// cf. https://youtu.be/FxW9Dxt896U?si=fj8sYCtM3Dg3DxhQ
struct AppTabBarView: View {
    private var tabs: [TabBarItem] = [.home, .favorites, .profile]
    @State private var selection: TabBarItem = .home
    
    var body: some View {
//        defaultTabView
        customTabView
    }
}

#Preview {
    AppTabBarView()
}

extension AppTabBarView {
    private var defaultTabView: some View {
        TabView(selection: $selection) {
            ForEach(tabs, id: \.self) { tab in
                tab.color
                    .tabItem {
                        Image(systemName: tab.iconName)
                        Text(tab.title)
                    }
            }
        }
    }
    
    private var customTabView: some View {
        CustomTabView(selection: $selection) {
            ForEach(tabs, id: \.self) { tab in
                tab.color
                    .tabBarItem(tab: tab, selection: $selection)
            }
        }
    }
}
