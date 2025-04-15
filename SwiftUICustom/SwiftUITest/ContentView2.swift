//
//  ContentView2.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/09/05.
//

import SwiftUI

struct ContentLengthPreference: PreferenceKey {
   static var defaultValue: CGFloat { 0 }
   static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value = nextValue()
   }
}

struct ContentView2: View {
    @State var textHeight: CGFloat = 0
    @State var text = String(repeating: "lorem ipsum ", count: 25)
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 0, height: textHeight) // <-- this
            
            Text(text)
                .overlay(
                    GeometryReader { proxy in
                        Color
                            .clear
                            .preference(key: ContentLengthPreference.self,
                                        value: proxy.size.height)
                    }
                )
        }
        .onPreferenceChange(ContentLengthPreference.self) { value in
            DispatchQueue.main.async {
                print("akb::value::\(value)")
                self.textHeight = value
            }
        }
        
        Button(action: {
            text.append("lorem ipsum ")
        }, label: {
            Text("++Button")
                .padding(20)
        })
        .tint(Color.white)
        .background(Color.black)
        .clipShape(Capsule())
        
        
        Button(action: {
            // Do something..
        }, label: {
            Image(systemName: !isPressed ? "square.and.arrow.down.fill" : "pencil")
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
        .buttonStyle(.plain)
        .pressAction {
            isPressed = true
        } onRelease: {
            isPressed = false
        }
        .frame(width: 100, height: 100)
        
        
        
    }
}


#Preview {
    ContentView2()
}

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}
 
 
extension View {
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}
