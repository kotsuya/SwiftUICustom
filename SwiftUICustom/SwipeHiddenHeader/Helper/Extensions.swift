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
}
