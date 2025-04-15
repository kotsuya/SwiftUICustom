//
//  SwiftUICustomApp.swift
//  SwiftUICustom
//
//  Created by Yoo on 2024/07/06.
//

import SwiftUI

@main
struct SwiftUICustomApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView(item: 0)
//            YoutubeHome()
//            AppTabBarView()
//            AppNavBarView()
//            FirstView()
//            UserListView()
//            VideoPlayerCustomContentView()
//            ListScrollTest()
            
//            CachedAsyncImageView()
//            ShimmerSwiftUIView()
//            HomeView()
            if #available(iOS 16.0, *) {
                SkeletonContentView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
