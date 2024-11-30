//
//  ScrollViewTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/22.
//

import SwiftUI

struct ScrollViewTest: View {
    @State private var items: [String] = ["One", "Two", "Three"]
    @State private var scrollViewSize: CGSize = .zero
    @State private var topMargin: CGFloat = 0
    
    var body: some View {
        if #available(iOS 16.4, *) {
            ScrollView {
                VStack {
                    HStack {
                        Button("++ items") {
                            items.insert(String.random(length: 10), at: 0)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(.red.opacity(0.2))
                        
                        Button("-- items") {
                            items.removeLast()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(.red.opacity(0.2))
                    }
                    .padding(.bottom, 20)
                    
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(Color.blue.opacity(0.2))
                    }
                    .frame(maxWidth: .infinity)
                }
                .modifier(SizeModifier())
                .frame(height: scrollViewSize.height)
            }
            .scrollBounceBehavior(.basedOnSize)
            .onPreferenceChange(SizePreferenceKey.self, perform: { value in
                scrollViewSize.height = value.height
                // calc topMargin
                topMargin = (UIScreen.main.bounds.height - safeArea().top - safeArea().bottom - scrollViewSize.height) / 2
                
                if topMargin < 20 {
                    topMargin = 20
                }
                
                print("akb::\(value.height) \(topMargin)")
                // 1. Calc Display Area Height
                // 2. Calc top margin = (1 - scroll height)
                // 3. Calc scroll enabled = top margin less than minHeight 20 or not
            })
            .padding(.horizontal, 20)
            .padding(.top, topMargin)
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    ScrollViewTest()
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }

    func body(content: Content) -> some View {
        content.overlay(sizeView)
    }
}

extension View {
    func getSize(perform: @escaping (CGSize) -> ()) -> some View {
        self
            .modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) {
                perform($0)
            }
    }
}

extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
