//
//  Extensions.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/13.
//

import SwiftUI

extension View {
    @ViewBuilder
    func offsetY(completion: @escaping (CGFloat, CGFloat) -> ()) -> some View {
        self
            .modifier(OffsetHelper(onChnage: completion))
    }
    
    func safeArea() -> UIEdgeInsets {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        guard let safeArea = scene.windows.first?.safeAreaInsets else { return .zero }
        return safeArea
    }
    
    var screenWidth: CGFloat {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        return scene.screen.bounds.width
    }
    
    var screenHeight: CGFloat {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        return scene.screen.bounds.height
    }
    
    var rootVC: UIViewController? {
        return UIApplication.shared.firstKeyWindow?.rootViewController ?? nil
    }
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow
    }
}
