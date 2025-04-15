//
//  ListScrollTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/12.
//

import SwiftUI

struct ListScrollTest: View {
    @State private var items: [Item] = (1...100).map { .init(id: $0) }
    @State private var displayItemIDs: Set<Int> = []
    
    @State private var tabIndex: Int = 0
    
    @Namespace private var namespace
    
    private var colors = [Color.red, Color.orange, Color.green]
    
    private var displayItems: [Item] {
        items.sorted { $0.id > $1.id }
    }
    
    private var title: String {
        guard let max = displayItemIDs.max().map({ "\($0)" }) else {
            return "Nothing"
        }
        let min = displayItemIDs.min().map { "\($0)" } ?? ""
        return "\(max) ~ \(min)"
    }
    
    private func setIndex(idx: Int) {
        if tabIndex != idx {
            tabIndex = idx
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
            .padding(.bottom, 10)
            .background(.white)
            .zIndex(2)
            
            ZStack(alignment: .top) {
                TabView(selection: $tabIndex) {
                    ForEach(0..<3, id:\.self) { idx in
                        contentView
                            .tag(idx)
                    }
                }
                .frame(maxHeight: .infinity)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.2), value: tabIndex)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .offset(y: -1)
                    .shadow(color: .black, radius: 1, x: 0, y: 1)
                    .zIndex(1)
            }
            .zIndex(0)
        }
        .ignoresSafeArea(edges: [.bottom])
    }
    
    @State private var isShow: Bool = false
        
    @ViewBuilder
    var contentView: some View {
        VStack {
            if isShow {
                Text("SCREEN::\(tabIndex)::\(title)")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(colors[tabIndex])
                    .onTapGesture {
                        withAnimation {
                            isShow.toggle()
                        }
                    }
                    .transition(.move(edge: .top))
                    .animation(.easeInOut, value: isShow)
            } else {
                Button {
                    withAnimation {
                        isShow.toggle()
                    }
                } label: {
                    Text("Show Banner")
                }
            }
            
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
    ContentView44()
//    ListScrollTest()
//    ContentView22()
//    ContentView33()
}

struct ContentView44: View {
    @State private var flag = true
    @State private var items = ["Item 1", "Item 2", "Item 3"]
    
    var body: some View {
        VStack {
//            ForEach(items, id: \.self) { item in
//                            Text(item)
//                                .padding()
//                                .background(Color.blue.opacity(0.2))
//                                .cornerRadius(8)
//                                .onDrag {
//                                    NSItemProvider(object: item as NSString)
//                                }
//                        }
//                        .onDrop(of: [.text], delegate: DropViewDelegate(items: $items))
            Text("Hello world!")
                .padding()
                .gesture(
                    DragGesture()
                        .onChanged { _ in
                            print("onChanged")
                        }
                        .onEnded { _ in
                            print("onEnded")
                        }
                    //                                 .updating(print("onChanged"))
                             )
                
            
            Button("トランジション") {
                withAnimation() {          // 明示的なアニメーション指定
                    self.flag.toggle()
                }
            }
            if flag {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)
                    .transition(.move(edge: .top))
            }
        }
    }
}

struct DropViewDelegate: DropDelegate {
    @Binding var items: [String]

    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [.text]).first else { return false }
        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
            if let data = data as? Data, let text = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    items.append(text)
                }
            }
        }
        return true
    }
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

struct CacheAsyncImage<Content>: View where Content: View{
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){                
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View{
        if let cached = ImageCache[url]{
            content(.success(cached))
        }else{
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ){phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    func cacheAndRender(phase: AsyncImagePhase) -> some View{
        if case .success (let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

fileprivate class ImageCache{
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image?{
        get{
            ImageCache.cache[url]
        }
        set{
            ImageCache.cache[url] = newValue
        }
    }
}
