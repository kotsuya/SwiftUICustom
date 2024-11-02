//
//  ToastsCustom.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/02.
//

import SwiftUI

struct ToastsCustomContentView: View {
    @State private var toasts: [Toast] = []
    var body: some View {
        NavigationView {
            List {
                Text("Dummy list row View")
            }
            .navigationTitle("Toasts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Show", action: showToast)
                }
            }
        }
        .interactiveToasts($toasts)
    }
    
    func showToast() {
        withAnimation(.bouncy) {
            let toast = Toast { id in
                ToastView(id)
            }
            
            toasts.append(toast)
        }
    }
    
    func ToastView(_ id: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "square.and.arrow.up.fill")
            
            Text("Hellow World")
                .font(.callout)
            
            Spacer(minLength: 0)
            
            Button {
                $toasts.delete(id)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
            }
        }
        .foregroundStyle(.primary)
        .padding(.vertical, 12)
        .padding(.leading, 15)
        .padding(.trailing, 10)
        .background {
            Capsule()
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 3, x: -1, y: -3)
                .shadow(color: .black.opacity(0.06), radius: 2, x: 1, y: 3)
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    ToastsCustomContentView()
}

struct Toast: Identifiable {
    private(set) var id: String = UUID().uuidString
    var content: AnyView
    init(@ViewBuilder content: @escaping (String) -> some View) {
        self.content = .init(content(id))
    }
    
    var offsetX: CGFloat = 0
    var isDeleting: Bool = false
}

extension View {
    @ViewBuilder
    func interactiveToasts(_ toasts: Binding<[Toast]>) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                ToastsView(toasts: toasts)
            }
    }
}

extension Binding<[Toast]> {
    func delete(_ id: String) {
        if let toast = first(where: { $0.id == id }) {
            toast.wrappedValue.isDeleting = true
        }
        
        withAnimation(.bouncy) {
            self.wrappedValue.removeAll(where: { $0.id == id })
        }
    }
}

struct ToastsView: View {
    @Binding var toasts: [Toast]
    @State private var isExpanded: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            if isExpanded {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isExpanded = false
                    }
            }
            
            if #available(iOS 16.0, *) {
                let layout = isExpanded ? AnyLayout(VStackLayout(spacing: 10)) : AnyLayout(ZStackLayout())
                
                layout {
                    ForEach($toasts) { $toast in
                        if #available(iOS 17.0, *) {
                            let index = (toasts.count-1) - (toasts.firstIndex(where: { $0.id == toast.id }) ?? 0)
                            toast.content
                                .visualEffect { [isExpanded] content, proxy in
                                    content
                                        .scaleEffect(isExpanded ? 1 : scale(index), anchor: .bottom)
                                        .offset(y: isExpanded ? 0 : offsetY(index))
                                }
                                .transition(.asymmetric(
                                    insertion: .offset(y: 100),
                                    removal: .move(edge: .leading)))
                                .offset(x: toast.offsetX)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            let xOffset = value.translation.width < 0 ? value.translation.width : 0
                                            toast.offsetX = xOffset
                                        })
                                        .onEnded({ value in
                                            let xOffset = value.translation.width + (value.velocity.width / 2)
                                            if -xOffset > 200 {
                                                $toasts.delete(toast.id)
                                            } else {
                                                toast.offsetX = 0
                                            }
                                        })
                                )
                                .zIndex(toast.isDeleting ? 1000 : 0)
                        } else {
                            toast.content
                        }
                    }
                }
                .onTapGesture {
                    isExpanded.toggle()
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .animation(.bouncy, value: isExpanded)
        .padding(.bottom, 15)
        .onChange(of: toasts.isEmpty) { value in
            if value {
                isExpanded = false
            }
        }
    }
    
    nonisolated func offsetY(_ index: Int) -> CGFloat {
        let offset = min(CGFloat(index) * 15, 30)
        return -offset
    }
    
    nonisolated func scale(_ index: Int) -> CGFloat {
        let scale = min(CGFloat(index) * 0.1, 1)
        return 1 - scale
    }
}
