//
//  YoutubeHome.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/13.
//

import SwiftUI

enum SwipeDirection {
    case up
    case down
    case none
}

struct YoutubeHome: View {
    @State var headerHeight: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var lastHeaderOffset: CGFloat = 0
    @State var direction: SwipeDirection = .none
    @State var shiftOffset: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Thumbnails()
                .padding(.top, headerHeight)
                .offsetY { previous, current in
                    if previous > current, current < 0 {
                        if direction != .up {
                            shiftOffset = current - headerOffset
                            direction = .up
                            lastHeaderOffset = headerOffset
                        }
                        
                        let offset = current < 0 ? (current - shiftOffset) : 0
                        headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
                    } else {
                        if direction != .down {
                            shiftOffset = current
                            direction = .down
                            lastHeaderOffset = headerOffset
                        }
                        
                        let offset = lastHeaderOffset + (current - shiftOffset)
                        headerOffset = offset > 0 ? 0 : offset
                    }
                    #if DEBUG
                    print("***************")
                    print("direction: \(direction)")
                    print("shiftOffset: \(shiftOffset)")
                    print("headerOffset: \(headerOffset)")
                    print("headerHeight: \(headerHeight)")
                    print("***************")
                    #endif
                }
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .top) {
            HeaderView()
                .anchorPreference(key: HeaderBoundsKey.self, value: .bounds) { $0 }
                .overlayPreferenceValue(HeaderBoundsKey.self, { value in
                    GeometryReader { proxy in
                        if let anchor = value {
                            Color.clear
                                .onAppear {
                                    headerHeight = proxy[anchor].height
                                }
                        }
                        
                    }
                })
                .offset(y: -headerOffset < headerHeight ? headerOffset : (headerOffset < 0 ? headerOffset : 0))
        }
        .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    func InnerTagView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<10, id: \.self) { idx in
                    Button(action: {
                        
                    }, label: {
                        Text("Button\(idx)")
                            .font(.callout)
                            .foregroundStyle(.black)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background {
                                Capsule()
                                    .fill(.black.opacity(0.08))
                            }
                    })
                    
                }
            }
            .padding(.horizontal, 15)
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 0) {
                HStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    
                    HStack(spacing: 20) {
                        ForEach(["display.and.arrow.down","bell","magnifyingglass"], id: \.self) { icon in
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 23, height: 23)
                                    .foregroundStyle(.black)
                            })
                        }
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .foregroundStyle(.black)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, 10)
                
                Divider()
                    .padding(.horizontal, -15)
            }
            .padding([.horizontal, .top], 15)
            
            InnerTagView()
                .padding(.bottom, 10)
        }
        .padding(.top, safeArea().top)
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func Thumbnails() -> some View {
        VStack(spacing: 20) {
            ForEach(0...10, id: \.self) { index in
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .frame(
                            width: size.width,
                            height: size.height
                        )
                }
                .frame(height: 200)
                .padding(.horizontal)
                
            }
        }
    }
}

#Preview {
    YoutubeHome()
}
