//
//  OptionalViewModifiers.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/03.
//

import SwiftUI

enum Effect: String, CaseIterable {
    case bounce
    case breathe
    case pulse
    case rotate
}

@available(iOS 18.0, *)
struct OptionalViewModifiers: View {
    @State private var effect: Effect = .bounce
    var body: some View {
        Group {
            Picker("", selection: $effect) {
                ForEach(Effect.allCases, id: \.rawValue) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(15)
            
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundStyle(.red.gradient)
                .modifiers { image in
                    switch effect {
                    case .bounce:
                        image.symbolEffect(.bounce)
                    case .breathe:
                        image.symbolEffect(.breathe)
                    case .pulse:
                        image.symbolEffect(.pulse)
                    case .rotate:
                        image.symbolEffect(.rotate)
                    }
                }
            
            Rectangle()
                .modifiers { rectangle in
                    switch effect {
                    case .bounce:
                        rectangle.fill(.red)
                    case .breathe:
                        rectangle.fill(.blue)
                    case .pulse:
                        rectangle.fill(.yellow)
                    case .rotate:
                        rectangle.fill(.green)
                    }
                }
                .frame(width: 200, height: 200)

            
//            switch effect {
//            case .bounce:
//                Image(systemName: "heart.fill")
//                    .font(.largeTitle)
//                    .foregroundStyle(.red.gradient)
//                    .symbolEffect(.bounce)
//            case .breathe:
//                Image(systemName: "heart.fill")
//                    .font(.largeTitle)
//                    .foregroundStyle(.red.gradient)
//                    .symbolEffect(.breathe)
//            case .pulse:
//                Image(systemName: "heart.fill")
//                    .font(.largeTitle)
//                    .foregroundStyle(.red.gradient)
//                    .symbolEffect(.pulse)
//            default:
//                Image(systemName: "heart.fill")
//                    .font(.largeTitle)
//                    .foregroundStyle(.red.gradient)
//                    .symbolEffect(.rotate)
//            }
        }
    }
}

extension View {
    func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        OptionalViewModifiers()
    } else {
        
    }
}
