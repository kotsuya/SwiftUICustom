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

#Preview {
    EscapingTest() {
        print("akbakb")
    }
}
