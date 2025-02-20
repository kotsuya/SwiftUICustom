//
//  ShimmerEffect.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/15.
//

import SwiftUI

extension View {
    func shimmer(_ config: ShimmerConfig) -> some View {
        modifier(ShimmerEffect(config: config))
    }
}

struct ShimmerEffect: ViewModifier {
    var config: ShimmerConfig
    @State private var moveTo: CGFloat = -0.7
    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask { content }
                    .overlay {
                        GeometryReader {
                            let size = $0.size
                            let extraOffset = size.height / 2.5
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(colors: [
                                                .white.opacity(0),
                                                config.highlight.opacity(config.highlightOpacity),
                                                .white.opacity(0)
                                            ], startPoint: .top, endPoint: .bottom)
                                        )
                                        .blur(radius: config.blur)
                                        .rotationEffect(.init(degrees: -70))
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        .mask { content }
                    }
                    .task {
                        await MainActor.run {
                            moveTo = 0.7
                        }
                    }
                    .animation(
                        .linear(duration: config.speed).repeatForever(autoreverses: false),
                        value: moveTo
                    )
            }
    }
}
      
struct ShimmerConfig {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 2
}

@available(iOS 16, *)
struct ShimmerContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Hello World!")
                    .font(.title)
                    .fontWeight(.black)
                    .shimmer(ShimmerConfig(tint: .white.opacity(0.5), highlight: .white, blur: 5))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.red.gradient)
                    )
                
                HStack(spacing: 15) {
                    ForEach(["suit.heart.fill", "box.truck.badge.clock.fill", "sun.max.trianglebadge.exclamationmark.fill"], id:\.self) { sfImage in
                        Image(systemName: sfImage)
                            .font(.title)
                            .fontWeight(.black)
                            .shimmer(.init(tint: .white.opacity(0.4), highlight: .white, blur: 5))
                            .frame(width: 40, height: 40)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.indigo.gradient)
                            }
                    }
                }
                
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
                .shimmer(.init(tint: .white.opacity(0.3), highlight: .white, blur: 5))
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.gradient)
                        .padding(5)
                        .padding(.horizontal, 10)
                )
            }
            .navigationTitle("Shimmer Effect")
            //.preferredColorScheme(.dark)
        }
    }
}

#Preview {
    if #available(iOS 16, *) {
        ShimmerContentView()
    } else {
        // Fallback on earlier versions
    }
}
