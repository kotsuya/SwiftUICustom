//
//  CustomNavHeaderView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/20.
//

import SwiftUI

struct CustomNavHeaderView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.isPresented) var isPresented
    
    let title: String
    let subtitle: String?
    let subtitleIcon: Image?
    let isHiddenBackButton: Bool
    let isHiddenCloseButton: Bool
    
    var body: some View {
        HStack {
            if !isHiddenBackButton {
                Button(action: {
                    if isPresented {
                        dismiss()
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                })
            }
            
            Spacer()
            
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                if let subtitle {
                    HStack(alignment: .center, spacing: 2) {
                        if let subtitleIcon {
                            subtitleIcon
                        }
                        Text(subtitle)
                    }
                }
            }
            
            Spacer()
            
            if !isHiddenBackButton {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "x.circle")
                })
                .opacity(isHiddenCloseButton ? 0.0 : 1.0)
            }
        }
        .padding()
        .font(.headline)
        .foregroundStyle(Color.white)
        .background(Color.blue)
    }
}

#Preview {
    VStack {
        CustomNavHeaderView(title: "Title Here", subtitle: "SubTitle Here", subtitleIcon: Image(systemName: "car.circle"), isHiddenBackButton: false, isHiddenCloseButton: false)
        Spacer()
    }
}

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = nil
    }
}
