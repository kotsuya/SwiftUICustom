//
//  NavBarPreferenceKeys.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/20.
//

import SwiftUI

struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct CustomNavBarSubtitlePreferenceKey: PreferenceKey {
    static var defaultValue: String? = nil
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
}

struct CustomNavBarSubtitleIconPreferenceKey: PreferenceKey {
    static var defaultValue: Image? = nil
    static func reduce(value: inout Image?, nextValue: () -> Image?) {
        value = nextValue()
    }
}

struct CustomNavBarIsHiddenBackButtonPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct CustomNavBarIsHiddenCloseButtonPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = true
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension View {
    func customNavBarTitle(_ title: String) -> some View {
        preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
    }
    
    func customNavBarSubtitle(_ subtitle: String?) -> some View {
        preference(key: CustomNavBarSubtitlePreferenceKey.self, value: subtitle)
    }
    
    func customNavBarSubtitleIcon(_ icon: Image?) -> some View {
        preference(key: CustomNavBarSubtitleIconPreferenceKey.self, value: icon)
    }
    
    func customNavBarIsHiddenBackButton(_ isHidden: Bool) -> some View {
        preference(key: CustomNavBarIsHiddenBackButtonPreferenceKey.self, value: isHidden)
    }
    
    func customNavBarIsHiddenCloseButton(_ isHidden: Bool) -> some View {
        preference(key: CustomNavBarIsHiddenCloseButtonPreferenceKey.self, value: isHidden)
    }
    
    func customNavBarItems(title: String = "",
                           subtitle: String? = nil,
                           icon: Image? = nil,
                           isHiddenBackButton: Bool = false,
                           isHiddenCloseButton: Bool = true) -> some View {
        self
            .customNavBarTitle(title)
            .customNavBarSubtitle(subtitle)
            .customNavBarSubtitleIcon(icon)
            .customNavBarIsHiddenBackButton(isHiddenBackButton)
            .customNavBarIsHiddenCloseButton(isHiddenCloseButton)
    }
}
