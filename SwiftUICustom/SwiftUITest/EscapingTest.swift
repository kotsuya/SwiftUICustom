//
//  EscapingTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/12.
//

import SwiftUI


class EscapingTestModel: ObservableObject {
    @Published var count: Int = 0
    
    func aaa() {
        print("aaa")
    }
}

struct EscapingTest: View {
    @StateObject var vm = EscapingTestModel()
    
    var action: () -> Void
    
    var body: some View {
        Button {
//            action()
            vm.aaa()
        } label: {
            Text("Button")
        }

    }
}

struct SwiftUICustomTests: View {
    var body: some View {
        EscapingTest() {
            print("akbakb")
        }
    }
}

struct AkbakbakbTest: View {
    var body: some View {
        Button {
        
        } label: {
            HStack {
                VStack {
                    Spacer()
                    Text("test")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
//                        .background(.red)
                }
            }
            .frame(height: 25)
            .frame(maxWidth: .infinity)
//            .background(.blue)
        }
//        .buttonStyle(SBButtonStyle(onTouchDown: {
//            print("TOUCH DOWN")
//        }, onTouchUp: {
//            print("TOUCH UP")
//        }))
        .buttonStyle(AKBButtonStyle())
        
    }
}

struct AKBButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.blue : Color.red)
    }
}

struct SBButtonStyle: ButtonStyle {
    let onTouchDown: () -> Void
    let onTouchUp: () -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { $0 ? onTouchDown() : onTouchUp() }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
    }
}

#Preview {
//    EscapingTest() {
//        print("akbakb")
//    }
    
    AkbakbakbTest()
}
