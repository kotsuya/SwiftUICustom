//
//  BannerCustom.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/07.
//

import SwiftUI

struct BannerCustom: View {
    
    @State private var showView: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                CustomButton(title: "Show Banner") {
                    withAnimation {
                        showView.toggle()
                    }
                }
                Spacer()
            }
            
            if showView {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
                    .frame(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.1
                    )
                    .transition(.move(edge: .top))
            }
        }
    }
}

#Preview {
    BannerCustom()
}
