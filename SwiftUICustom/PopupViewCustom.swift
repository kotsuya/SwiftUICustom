//
//  PopupViewCustom.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/09/03.
//

import SwiftUI

struct PopupViewCustom: View {
    
    @State private var isPresented: Bool = Bool()
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Show Custom PopUp View") { isPresented.toggle() }                
            }
            .navigationTitle("Navigation Title")
        }
        .customPopupView(isPresented: $isPresented, 
                         popupView: { popupView })
    }
    
    var popupView: some View {
        RoundedRectangle(cornerRadius: 20.0)
            .fill(Color.white)
            .frame(width: 300.0, height: 200.0)
            .overlay(
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 10.0, height: 10.0)
                    .foregroundColor(Color.black)
                    .padding(5.0)
                    .background(Color.red)
                    .clipShape(Circle())
                    .padding()
                    .onTapGesture { isPresented.toggle() }
                , alignment: .topLeading)
            .overlay(Text("Custom PopUp View!"))
            .transition(AnyTransition.scale)
            .shadow(radius: 10.0)
    }
}


struct CustomPopupView<Content, PopupView>: View where Content: View, PopupView: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let popupView: () -> PopupView
    let backgroundColor: Color
    let animation: Animation?
    
    var body: some View {
        content()
            .animation(nil, value: isPresented)
            .overlay(isPresented ? backgroundColor.ignoresSafeArea() : nil)
            .overlay(isPresented ? popupView() : nil)
            .animation(animation, value: isPresented)
        
    }
}

extension View {
    func customPopupView<PopupView>(
        isPresented: Binding<Bool>,
        popupView: @escaping () -> PopupView,
        backgroundColor: Color = .black.opacity(0.7),
        animation: Animation? = .default
    ) -> some View where PopupView: View {
        return CustomPopupView(isPresented: isPresented, 
                               content: { self },
                               popupView: popupView,
                               backgroundColor: backgroundColor,
                               animation: animation)
    }
}

#Preview {
    PopupViewCustom()
}
