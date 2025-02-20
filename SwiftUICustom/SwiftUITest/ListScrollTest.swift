//
//  ListScrollTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/12.
//

import SwiftUI

struct ListScrollTest: View {
    @State var items: [Item] = (1...100).map { .init(id: $0) }
    @State var displayItemIDs: Set<Int> = []
    
    @State var tabIndex: Int = 0
    
    @Namespace var namespace
    
    var colors = [Color.red, Color.blue, Color.green, Color.orange, Color.accentColor]
    
    var displayItems: [Item] {
        items.sorted { $0.id > $1.id }
    }
    
    var title: String {
        guard let max = displayItemIDs.max().map({ "\($0)" }) else {
            return "Nothing"
        }
        
        let min = displayItemIDs.min().map { "\($0)" } ?? ""
        
        return "\(max) ~ \(min)"
    }
    
    func setIndex(idx: Int) {
        if tabIndex != idx {
            tabIndex = idx
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<3, id:\.self) { idx in
                    Button(action: {
                        withAnimation(.spring) {
                            setIndex(idx: idx)
                        }
                    }, label: {
                        Text("Button::\(idx)")
                    })
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 44)
                    .background {
                        if tabIndex == idx {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.2))
                                .matchedGeometryEffect(id: "button_bg", in: namespace)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            TabView(selection: $tabIndex) {
                ForEach(0..<3, id:\.self) { idx in
                    contentView
                        .tag(idx)
                }
            }
            .frame(maxHeight: .infinity)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: tabIndex)
        }
        .ignoresSafeArea(edges: [.bottom])
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack {
            Text("SCREEN: \(tabIndex)::\(title)")
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(colors[tabIndex])
            
            ScrollViewReader { proxy in
                List {
                    ForEach(displayItems) { item in
                        Label("\(item.id)", systemImage: "person")
                            .id(item.id)
                            .onAppear {
                                print("\(tabIndex)::\(item.id)")
                                displayItemIDs.insert(item.id)
                            }
                            .onDisappear { displayItemIDs.remove(item.id) }
                    }
                }
                .listStyle(.plain)
                .onFirstAppear {
                    proxy.scrollTo(Int.random(in: 20..<100), anchor: .top)
                }
            }
        }
    }
}

extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }
}

struct ViewFirstAppearModifier: ViewModifier {
    @State private var didAppearBefore = false
    private let action: () -> Void

    init(perform action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppearBefore else { return }
            didAppearBefore = true
            action()
        }
    }
}

struct Item: Identifiable {
  let id: Int
}

#Preview {
//    ContentView22()
    ListScrollTest()
//    ContentView33()
}

struct PageView: View {
    @State var idx: Int
    init(index: Int) {
        idx = index
    }
    
    var body: some View {
        Text("Page:\(idx)")
    }
}

struct ContentView33: View {
    func setIndex(idx: Int) {
        if tabIndex == idx { return }
        tabIndex = idx
    }
    @State var tabIndex: Int = 0
    @Namespace var namespace
    var body: some View {
        HStack {
            ForEach(0..<3, id:\.self) { idx in
                Button(action: {
                    withAnimation(.spring) {
                        setIndex(idx: idx)
                    }
                }, label: {
                    Text("Button::\(idx)")
                })
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 44)
                .background {
                    if tabIndex == idx {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.2))
                            .matchedGeometryEffect(id: "button_bg", in: namespace)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

struct ContentView22: View {
    
    @State var currentTab: Int = 0

    var body: some View {
        VStack {
            
            TabView(selection: $currentTab) {
                PageView(index: 1).tag(0)
                PageView(index: 2).tag(1)
                PageView(index: 3).tag(2)
            }
            .frame(maxHeight: .infinity)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentTab)
            
            HStack(spacing: 32) {
                Button("Page.1") {
                    currentTab = 0
                }
                .padding()
                Button("Page.2") {
                    currentTab = 1
                }
                .padding()
                Button("Page.3") {
                    currentTab = 2
                }
                .padding()
            }
            
        }
        .padding()
    }

}
