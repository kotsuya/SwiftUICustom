//
//  PopupTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/26.
//

import SwiftUI


struct aaabbb {
    let aaa: Int
    let bbb: Int?
}

class TestViewModel: ObservableObject {
    
    func aaa() {
        let ooo = aaabbb(aaa: 1, bbb: nil)
        guard let aaa = ooo.bbb as? Int? else { return }
        
    }
    
}

struct HomeView: View {
    @Namespace var namespace
    @State var isDisplay = true

    var body: some View {
        ZStack {
            if isDisplay {
//                View1(namespace: namespace, isDisplay: $isDisplay)
                View1(namespace: namespace, isDisplay: $isDisplay)
            } else {
                View2(namespace: namespace, isDisplay: $isDisplay)
            }
        }
    }
}

struct View1<Model>: View where Model: TestViewModel {
    let namespace: Namespace.ID
    @Binding var isDisplay: Bool
    var body: some View {
        VStack {
            Image("plant")
                .resizable()
                .frame(width: 150, height: 100)
                .matchedGeometryEffect(id: "img", in: namespace)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
        .onTapGesture {
            withAnimation {
                self.isDisplay.toggle()
            }
        }
    }
}

struct View2: View {
    let namespace: Namespace.ID
    @Binding var isDisplay: Bool
    var body: some View {
        VStack {
            Spacer()
            Image("plant")
                .resizable()
                .frame(width: 300, height: 200)
                .matchedGeometryEffect(id: "img", in: namespace)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .onTapGesture {
            withAnimation {
                self.isDisplay.toggle()
            }
        }
    }
}

#Preview {
    HomeView()
}
