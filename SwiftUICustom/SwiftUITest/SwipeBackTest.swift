//
//  SwipeBackTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/03/18.
//

import SwiftUI

@available(iOS 16, *)
struct ContentView99: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination:
                            SecondView()
            ) {
                Text("Go to Detail")
            }
            .navigationTitle("Main")
        }
    }
}

@available(iOS 16, *)
struct DetailView: View {
    var body: some View {
        Text("Detail View")
            .navigationBarBackButtonHidden(true)
            
//            .toolbar(.hidden, for: .navigationBar)
//            .navigationBarBackButtonHidden()
    }
}


@available(iOS 16, *)
struct SwipeBackTest: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                SecondView()
            } label: {
                Text("TEST")
            }

        }
    }
}

struct SecondView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("SecondView")
        }
       // .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(
//            leading: Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
//            Text("Custom go back")
//        })
//        .toolbar {
//            Rectangle().fill(Color.red).frame(maxWidth: .infinity).frame(height: 44)
//        }
//        .onAppear {
//                    AppState.shared.swipeEnabled = false
//                }
//                .onDisappear {
//                    AppState.shared.swipeEnabled = true
//                }
//        .edgeSwipe()
    }
}

#Preview {
    if #available(iOS 16, *) {
//        SwipeBackTest()
        ContentView99()
    } else {
        // Fallback on earlier versions
    }
}

//class AppState {
//    static let shared = AppState()
//
//    var swipeEnabled = false
//}

//extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }

//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if AppState.shared.swipeEnabled {
//            return viewControllers.count > 1
//        }
//        return false
//    }
//    
//}


//extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}

//extension UINavigationController {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = nil
//    }
//}
//
