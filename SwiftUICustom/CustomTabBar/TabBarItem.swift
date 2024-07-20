//
//  TabBarItem.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/14.
//

import SwiftUI

enum TabBarItem: Hashable {
    case home
    case favorites
    case profile
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .favorites: return "heart"
        case .profile: return "person"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .favorites: return "Favorites"
        case .profile: return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return Color.red
        case .favorites: return Color.orange
        case .profile: return Color.green
        }
    }
    
    static func testMock() -> [TabBarItem] {
        return  [.home, .favorites, .profile]
    }
}
