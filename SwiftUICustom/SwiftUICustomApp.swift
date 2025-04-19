//
//  SwiftUICustomApp.swift
//  SwiftUICustom
//
//  Created by Yoo on 2024/07/06.
//

import SwiftUI

@main
struct SwiftUICustomApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    
    var body: some Scene {
        WindowGroup {
            NetworkMonitorContentView()
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .environment(\.connectionType, networkMonitor.connectionType)
        }
    }
}
