//
//  CustomTabContainerView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/14.
//

import SwiftUI

struct CustomTabContainerView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                VStack {
                    Image(systemName: tab.iconName)
                    Text(tab.title)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(localSelection == tab ? tab.color : Color.gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if localSelection == tab {
                           RoundedRectangle(cornerRadius: 10)
                                .fill(tab.color.opacity(0.2))
                                .matchedGeometryEffect(id: "selected_rectangle", in: namespace)
                        }
                    }
                )
                .onTapGesture {
                    switchToTab(tab: tab)
                }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .onChange(of: selection, perform: { value in
            withAnimation(.easeInOut) {
                localSelection = value
            }
        })
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabContainerView(tabs: TabBarItem.testMock(),
                         selection: .constant(.home), localSelection: .home)
    }
}
