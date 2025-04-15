//
//  NavigatioinLinkTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/21.
//

import SwiftUI
import SafariServices

struct NavigatioinLinkTest: View {
    @State var isSafariWebViewShow: Bool = false
    let url = URL(string: "https://qiita.com/strings/items/9f363f728b61d2c760cd")!
    @State var isShowSheet: Bool = false
    
    var body: some View {
        VStack {
            Button {
                isSafariWebViewShow = true
                withAnimation {
                    isShowSheet = true
                }
                
            } label: {
                Text("詳しく見る")
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .overlay(isShowSheet ? FullScreen(isShowSheet: $isShowSheet.animation()).transition(.move(edge: .leading)).edgeSwipe() : nil)
        
//        .fullScreenCover(isPresented: $isSafariWebViewShow, content: {
//            SafariWebView(url: url, onClose: {
//                isSafariWebViewShow = false
//            })
//            .transition(.move(edge: .leading))
//        })
        
//        NavigationView {
//            List {
//                NavigationLink {
//                    if #available(iOS 16.0, *) {
//                        SafariWebView(url: url, onClose: {})
//                            .toolbar(.hidden, for: .navigationBar)
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                } label: {
//                    Text("1")
//                }
//
//            }
//        }
    }
}

struct FullScreen: View {
    
    @Binding var isShowSheet: Bool
    
    var body: some View {
        Color.blue
            .transition(.move(edge: .trailing))
            .onTapGesture {
                isShowSheet = false
            }
            .edgesIgnoringSafeArea(.all)
    }
}

struct EdgeSwipe: ViewModifier {
    @Environment(\.dismiss) var dismiss

    private let edgeWidth: Double = 30
    private let baseDragWidth: Double = 30
    
    func body(content: Content) -> some View {
        content
            .gesture (
                DragGesture().onChanged { value in
                    if value.startLocation.x < edgeWidth && value.translation.width > baseDragWidth {
                        dismiss()
                    }
                }
            )
    }
}

extension View {
    
    func edgeSwipe() -> some View {
        self.modifier(EdgeSwipe())
    }
}

struct SafariWebView: UIViewControllerRepresentable {
    var url: URL
    var onClose: () -> Void
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = context.coordinator
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        var parent: SafariWebView
        
        init(_ safariWebView: SafariWebView) {
            self.parent = safariWebView
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            parent.onClose()
        }
    }
}

#Preview {
    NavigatioinLinkTest()
}
