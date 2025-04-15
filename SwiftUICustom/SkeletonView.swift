//
//  SkeletonView.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/04/16.
//

import SwiftUI

struct SkeletonView<S: Shape>: View {
    var shape: S
    var color: Color
    
    init(_ shape: S, _ color: Color = .gray.opacity(0.3)) {
        self.shape = shape
        self.color = color
    }
    @State private var isAnimating: Bool = false
    var body: some View {
        shape
            .fill(color)
            .overlay {
                GeometryReader { proxy in
                    let size = proxy.size
                    let skeletonWidth = size.width / 2
                    let blurRadius: CGFloat = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRadius * 2
                    let minX = -(skeletonWidth + blurDiameter)
                    let maxX = size.width + skeletonWidth + blurDiameter
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRadius)
                        .rotationEffect(.init(degrees: rotation))
                        .blendMode(.softLight)
                        .offset(x: isAnimating ? maxX : minX)
                }
            }
            .clipShape(shape)
            .compositingGroup()
            .onAppear {
                guard !isAnimating else { return }
                withAnimation(animation) {
                    isAnimating = true
                }
            }
            .onDisappear {
                isAnimating = false
            }
            .transaction {
                if $0.animation != animation {
                    $0.animation = .none
                }
            }
        
    }
    
    var rotation: Double {
        return 5
    }
    
    var animation: Animation {
        .easeIn(duration: 1.5).repeatForever(autoreverses: false)
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    @Previewable
//    @State var isTapped: Bool = false
//
//    SkeletonView(.circle)
//        .frame(width: 100, height: 100)
//        .onTapGesture {
//            withAnimation {
//                isTapped.toggle()
//            }
//        }
//        .padding(.bottom, isTapped ? 15 : 0)
//}

@available(iOS 16.0, *)
struct SelectionContentView: View {
    @State private var isLoading: Bool = false
    @State private var cards: [Card] = []
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                if cards.isEmpty {
                    ForEach(0..<3, id:\.self) { _ in
                        SelectonCardView()
                    }
                } else {
                    ForEach(cards) { card in
                        SelectonCardView(card: card)
                    }
                }
            }
            .padding(20)
        }
        .scrollDisabled(cards.isEmpty)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .onTapGesture {
            withAnimation(.smooth) {
                cards = [.init(
                    image: "wwdc25",
                    title: "AppleのWorldwide Developers Conference、6月9日（米国太平洋時間）の週に開催",
                    subTitle: "すべてのデベロッパはWWDC25全体にオンラインで無料で参加できます",
                    description: "カリフォルニア州クパティーノ Appleは本日、毎年開催しているWorldwide Developers Conference（WWDC）を2025年6月9日から13日（米国太平洋時間）にオンライン形式で開催することを発表しました。6月9日（米国太平洋時間）にApple Parkで開催される特別なイベントでは、デベロッパと学生が交流する場も設けられます。")]
            }
        }
    }
}

struct Card: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    var subTitle: String
    var description: String
}

struct SelectonCardView: View {
    var card: Card?
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    if let card {
                        Image(card.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        SkeletonView(.rect)
                    }
                }
                .frame(height: 220)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                if let card {
                    Text(card.title)
                        .fontWeight(.semibold)
                } else {
                    SkeletonView(.rect(cornerRadius: 5))
                        .frame(height: 20)
                }
                
                Group {
                    if let card {
                        Text(card.subTitle)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } else {
                        SkeletonView(.rect(cornerRadius: 5))
                            .frame(height: 15)
                    }
                }
                .padding(.trailing, 30)
                
                ZStack {
                    if let card {
                        Text(card.description)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    } else {
                        SkeletonView(.rect(cornerRadius: 5))
                    }
                }
                .frame(height: 50)
                .lineLimit(3)
            }
            .padding(.horizontal, 15)
            .padding(.top, 15)
            .padding(.bottom, 25)
        }
        .background(.background)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

@available(iOS 16.0, *)
#Preview {
    SelectionContentView()
}
