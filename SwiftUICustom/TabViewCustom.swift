//
//  CustomTabView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/21.
//

import SwiftUI

struct CustomTabView: View {
    var tabs = ["house", "mail", "folder", "gearshape"]
    
    @State var selectedTab = "house"
    var edge = UIApplication.shared.windows.first?.safeAreaInsets

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {

            TabView(selection: $selectedTab) {
                Color.red
                    .tag("house")

                Email()
                    .tag("mail")

                Folder()
                    .tag("folder")

                Settings()
                    .tag("gearshape")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all, edges: .bottom)

            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    TabButton(image: image, selectedTab: $selectedTab)

                    if image != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .padding(.bottom, edge!.bottom == 0 ? 20 : 0)
        })
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(
            Color.black
                .opacity(0.05)
                .ignoresSafeArea()
        )
    }
}

struct Home: View {
    var body: some View {
        VStack {
            Text("Home")
        }
    }
}

struct Email: View {
    var body: some View {
        VStack {
            Text("Email")
        }
    }
}

struct Folder: View {
    var body: some View {
        VStack {
            Text("Folder")
        }
    }
}

struct Settings: View {
    var body: some View {
        VStack {
            Text("Settings")
        }
    }
}

struct TabButton: View {
    var image: String
    @Binding var selectedTab: String
    var body: some View {
        Button(action: {
            selectedTab = image
        }, label: {
            Image(systemName: image)
                .font(.system(size: 22))
                .foregroundColor(selectedTab == image ? Color(UIColor.systemBlue) : Color.black.opacity(0.4))
                .padding()
        })
    }
}

#Preview {
    CustomTabView()
}
