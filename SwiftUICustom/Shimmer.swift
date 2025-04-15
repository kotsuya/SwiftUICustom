//
//  Shimmer.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/21.
//

import SwiftUI

struct ShimmerSwiftUIView: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.red)
                .frame(width: 55, height: 55)
                        
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.cyan)
                    .frame(height: 10)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.cyan)
                    .frame(height: 10)
                    .padding(.trailing, 50)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.cyan)
                    .frame(height: 10)
                    .padding(.trailing, 100)
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .modifier(Shimmer())
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray)
                .frame(height: 80)
        }
    }
}

public struct Shimmer: ViewModifier {
    
    @State var isInitialState: Bool = true
    
    @State var startPoint: UnitPoint = .init(x: -0.3, y: 0)
    @State var endPoint: UnitPoint = .init(x: 0, y: 0)
    
    let speed = 1.5
    let delay = 0 // 0.25
    
    public func body(content: Content) -> some View {
        content
            .mask {
                LinearGradient(
                    gradient: .init(colors: [
                        Color.white.opacity(0.4),
                        Color.white,
                        Color.white.opacity(0.4)
                    ]),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            }
            .animation(.linear(duration: speed).delay(TimeInterval(delay)).repeatForever(autoreverses: false), value: isInitialState)
            .onAppear() {
                isInitialState = false
                
                startPoint = .init(x: 1, y: 0)
                endPoint = .init(x: 1.3, y: 0)
            }
    }
}


#Preview {
    ShimmerSwiftUIView()
}
