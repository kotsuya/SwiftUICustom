//
//  ExtractUIKitView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/30.
//

import SwiftUI

struct ExtractUIKitView: View {
    var body: some View {
        TextField("Hello, World!", text: .constant(""))
            .viewExtractor { view in
                if let textView = view as? UITextField {
                    print(textView)
                }
            }
        
        Slider(value: .constant(0.2))
            .viewExtractor { view in
                if let slider = view as? UISlider {
                    print(slider)
                    slider.tintColor = .red
                    slider.thumbTintColor = .blue
                }
            }
        
        List {
            Text("Hellow World!")
        }
        .viewExtractor { view in
            if let collectionView = view as? UICollectionView {
                print(collectionView)
            }
        }
        
        ScrollView {
            Text("Hellow World!")
        }
        .viewExtractor { view in
            if let scrollView = view as? UIScrollView {
                print(scrollView)
                scrollView.bounces = false
            }
        }
        
        if #available(iOS 16.0, *) {
            NavigationStack {
                List {
                    
                }
                .navigationTitle("Home")
            }
            .viewExtractor { view in
                if let naviController = view.next as? UINavigationController {
                    print(naviController)
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        TabView {
            
        }
        .viewExtractor { view in
            if let tabController = view.next as? UITabBarController {
                print(tabController)
                tabController.tabBar.isHidden = true
            }
        }
        
    }
}

#Preview {
    ExtractUIKitView()
}

extension View {
    @ViewBuilder
    func viewExtractor(result: @escaping (UIView) -> ()) -> some View {
        self
            .background(ViewExtractHelper(result: result))
    }
}

fileprivate struct ViewExtractHelper: UIViewRepresentable {
    var result: (UIView) -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.async {
            if let uiKitView = view.superview?.superview?.subviews.last?.subviews.first {
                result(uiKitView)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
