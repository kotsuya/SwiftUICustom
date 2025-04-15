//
//  AsyncImageTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/19.
//

import SwiftUI

struct AsyncImageTest: View {
    @State var refresh = false
    
    init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cachesDirectory: URL = paths[0]
        print("akb: cachesDirectory: \(cachesDirectory)")
    }
    
    var body: some View {
        VStack {
            Button(action: { refresh.toggle() }) {
                Text("RELOAD")
            }
            AsyncImage(url: URL(string: "https://placehold.jp/150x150.png")) { image in
                image.resizable(resizingMode: .tile).frame(width: 200, height: 200)
            } placeholder: {
                Color.green
            }
        }
    }
}

#Preview {
    AsyncImageTest()
}
