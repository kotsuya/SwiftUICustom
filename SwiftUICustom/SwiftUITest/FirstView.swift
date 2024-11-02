//
//  FirstView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/09/06.
//

import SwiftUI

extension View {
    func withoutAnimation() -> some View {
        return self.transaction { (tx: inout Transaction) in
            tx.disablesAnimations = true
            tx.animation = nil
        }.animation(nil, value: UUID())
    }
}

struct Attribute: Hashable {
    let name: String
    let value: String
}

class FirstViewModel: ObservableObject {
    @Published var textArray: [Attribute] = [
        Attribute(name: "Title1", value: "I wanted to create a list (without using List view) of attributes."),
        Attribute(name: "Title222", value: "Each attribute is a HStack which contains two texts"),
        Attribute(name: "Title33333", value: "name and value. ")
    ]
}

struct FirstView: View {
    @ObservedObject var viewModel = FirstViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    @State var contentHeight: CGFloat = .zero
    
    var body: some View {
        Text("\(contentHeight)")
        
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 0, height: contentHeight)
            
            VStack(spacing: 10) {
                ForEach(viewModel.textArray, id: \.self) { attribute in
                    ChildView(attribute: attribute)
                }
                
                Spacer().frame(height: 20)
                
                Divider()
                
                Spacer().frame(height: 20)
                HStack(spacing: 40) {
                    Button(action: {
                        viewModel.textArray.append(
                            Attribute(name: "Title33333", value: "name and value. ")
                        )
                    }, label: {
                        Text("++Button")
                            .padding(10)
                    })
                    .accentColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    
                    Button(action: {
                        viewModel.textArray.removeLast()
                    }, label: {
                        Text("--Button")
                            .padding(10)
                    })
                    .accentColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
                }
            }
            .withoutAnimation()
            .padding(20)
            .background(Color.gray)
            .overlay(
               GeometryReader { proxy in
                 Color.clear
                    .preference(key: ViewHeightKey.self,
                                value: proxy.size.height)
               }
            )
        }
        .onPreferenceChange(ViewHeightKey.self) { value in
            DispatchQueue.main.async {
                print("akb::value::\(value)")
                self.contentHeight = value
            }
        }
//        .onChange(of: scenePhase) { newPhase in
//            switch newPhase {
//            case .inactive:
//                print("Foreground inactive")
//            case .active:
//                print("Foreground")
//            case .background:
//                print("Background")
//            @unknown default:
//                break
//            }
//        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                print("akb::Foreground")
                NSLog("Debug Message")
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
}

struct ChildView: View {
    let attribute: Attribute

    @State private var fitHeight = CGFloat.zero

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                Text(attribute.name)
                    .bold()
                    .frame(width: 0.3 * geometry.size.width, alignment: .leading)
                    .background(Color.yellow)
                Text(attribute.value)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 0.7 * geometry.size.width, alignment: .leading)
            }
            .background(Color.red)
            .background(
                GeometryReader {
                    Color.clear.preference(
                        key: ViewHeightKey.self,
                        value: $0.frame(in: .local).size.height)
                }
            )
        }
        .onPreferenceChange(ViewHeightKey.self) {
            self.fitHeight = $0
        }
        .frame(height: fitHeight)
    }
}

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

#Preview {
    FirstView()
}
