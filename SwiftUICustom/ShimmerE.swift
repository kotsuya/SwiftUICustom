//
//  ShimmerE.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/21.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    let configuration: ShimmerConfiguration
    func body(content: Content) -> some View {
        ShimmeringView(configuration: configuration) { content }
    }
}

extension View {
    func shimmer(_ configuration: ShimmerConfiguration) -> some View {
        modifier(ShimmerModifier(configuration: configuration))
    }
}

struct ShimmerConfiguration {
    var color: Color = .red
    var speed: CGFloat = 1.2
    var delay: CGFloat = 0.2
}

struct ShimmeringView<Content: View>: View {
    private let configuration: ShimmerConfiguration
    private let content: () -> Content
    @State private var startPoint: UnitPoint
    @State private var endPoint: UnitPoint
    
    init(configuration: ShimmerConfiguration, @ViewBuilder content: @escaping () -> Content) {
        self.configuration = configuration
        self.content = content
        _startPoint = .init(wrappedValue: UnitPoint(x: -0.3, y: 0))
        _endPoint = .init(wrappedValue: UnitPoint(x: 0, y: 0))
    }
    var body: some View {
        ZStack {
            content()
            LinearGradient(
                colors: [
                    configuration.color.opacity(0.3),
                    configuration.color,
                    configuration.color.opacity(0.3)
                ],
                startPoint: startPoint,
                endPoint: endPoint
            )
            .blendMode(.screen)
            .onAppear {
                withAnimation(Animation.linear(duration: configuration.speed).delay(TimeInterval(configuration.delay)).repeatForever(autoreverses: false)) {
                    startPoint = UnitPoint(x: 1, y: 0)
                    endPoint = UnitPoint(x: 1.3, y: 0)
                }
            }
        }
    }
}

struct ShimmerE: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 55, height: 55)
            
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 10)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 10)
                    .padding(.trailing, 50)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 10)
                    .padding(.trailing, 100)
            }
        }
        .padding(15)
        .padding(.horizontal, 30)
        .shimmer(ShimmerConfiguration())
    }
}

#Preview {
    ShimmerE()
}
