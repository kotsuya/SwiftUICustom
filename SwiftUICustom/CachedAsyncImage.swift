//
//  CachedAsyncImage.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/20.
//

import SwiftUI

@MainActor
struct CachedAsyncImage<ImageView: View, PlaceholderView: View>: View {
    var url: URL?
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView
    
    @State var image: UIImage? = nil
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> ImageView,
        @ViewBuilder placeholder: @escaping () -> PlaceholderView
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .task {
                        image = await downloadImage()
                    }
            }
        }
    }
    
    private func downloadImage() async -> UIImage? {
        guard let url = url else { return nil }
        do {
            if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
                print("akb: already exist: \(url.absoluteString)")
                return UIImage(data: cachedResponse.data)
            } else {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: URLRequest(url: url))
               
                print("akb: downloading image: \(url.absoluteString)")
                
                guard let image = UIImage(data: data) else { return nil }
                
                return image
            }
        } catch {
            print("akb: Error downloading image: \(error)")
            return nil
        }
    }
}

struct CachedAsyncImageView: View {
    //https://picsum.photos/id/42/600
    var url = URL(string: "https://placehold.jp/150x150.png")!
    var body: some View {
        CachedAsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    CachedAsyncImageView()
}
