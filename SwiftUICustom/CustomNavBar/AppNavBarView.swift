//
//  AppNavBarView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/20.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
//        defaultNavBarView
        customNavBarView
    }
}

#Preview {
    AppNavBarView()
}

extension AppNavBarView {
    private var defaultNavBarView: some View {
        NavigationView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                NavigationLink(destination: 
                                Text("destination")
                ) {
                    Text("Navigation Link")
                }
            }
            .navigationTitle("Navigation Title")
        }
    }
    
    private var customNavBarView: some View {
        CustomNavBarView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                CustomNavLink(
                    destination: Text("destination")
                        .customNavBarTitle("Second Title")
                        .customNavBarSubtitle("Second Subtitle Here!!!")
                ) {
                    Text("Navigation Link")
                }
            }
//            .customNavBarTitle("Title!")
//            .customNavBarIsHiddenBackButton(true)
            .customNavBarItems(title: "Title!",
                               isHiddenBackButton: true)
        }
    }
}
