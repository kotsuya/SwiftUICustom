//
//  VideoPlayerCustom.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/08/06.
//

import SwiftUI
import AVKit

struct VideoPlayerCustomContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            VideoPlayerCustomHome(size: size)
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
}

struct VideoPlayerCustomHome: View {
    var size: CGSize
    @State private var player: AVPlayer? = {
        if let bundle = Bundle.main.path(forResource: "mountain", ofType: "mp4") {
            return .init(url: URL(fileURLWithPath: bundle))
        }
        return nil
    }()
    @State private var showPlayerControls: Bool = false
    @State private var isPlaying: Bool = false
    @State private var timeoutTask: DispatchWorkItem?
    @State private var isFinishedPlaying: Bool = false
    
    @GestureState private var isDragging: Bool = false
    @State private var isSeeking: Bool = false
    @State private var progress: CGFloat = 0.0
    @State private var lastDraggingProgress: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            let videoPlayerSize: CGSize = .init(width: size.width, height: size.height / 3.5)
            
            ZStack {
                if let player {
                    CustomVideoPlayer(player: player)
                        .overlay {
                            Rectangle()
                                .fill(.black.opacity(0.4))
                                .opacity(showPlayerControls || isDragging ? 1 : 0)
                                .animation(.easeInOut(duration: 0.35), value: isDragging)
                                .overlay {
                                    PlayBackControls()
                                }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showPlayerControls.toggle()
                            }
                            
                            if isPlaying {
                                timeoutContols()
                            }
                        }
                        .overlay(alignment: .bottom) {
                            VideoSeekerView(videoPlayerSize)
                        }
                }
            }
            .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { index in
                        GeometryReader {
                            let size = $0.size
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.gray.opacity(0.2))
                                .frame(width: size.width, height: size.height)
                        }
                        .frame(height: 200)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 30)
                .padding(.bottom, 15 + safeArea().bottom)
            }
        }
        .padding(.top, safeArea().top)
        .onAppear {
            player?.addPeriodicTimeObserver(
                forInterval: .init(seconds: 1, preferredTimescale: 1),
                queue: .main,
                using: { time in
                    if let currentPlayerItem = player?.currentItem,
                       let currentDuration = player?.currentTime() {
                        let totalDuration = currentPlayerItem.duration.seconds
                        let calculatedProgress = currentDuration.seconds / totalDuration
                        
                        if !isSeeking {
                            progress = calculatedProgress
                            lastDraggingProgress = progress
                        }
                        
                        if calculatedProgress == 1 {
                            isFinishedPlaying = true
                            isPlaying = false
                        }
                    }
                })
        }
    }
    
    func VideoSeekerView(_ videoPlyerSize: CGSize) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray)
            
            Rectangle()
                .fill(.red)
                .frame(width: max(size.width * progress, 0))
        }
        .frame(height: 3)
        .overlay(alignment: .leading) {
            Circle()
                .fill(.red)
                .frame(width: 15, height: 15)
                .scaleEffect(showPlayerControls || isDragging ? 1 : 0.001, anchor: progress * size.width > 15 ? .center : .trailing)
                .frame(width: 50, height: 50)
                .contentShape(Rectangle())
                .offset(x: size.width * progress)
                .gesture(
                    DragGesture()
                        .updating($isDragging, body: { _, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            if let timeoutTask {
                                timeoutTask.cancel()
                            }
                            let translationX: CGFloat = value.translation.width
                            let calculatedProgress = (translationX / videoPlyerSize.width) + lastDraggingProgress
                            progress = max(min(calculatedProgress, 1), 0)
                            isSeeking = true
                        })
                        .onEnded({ value in
                            lastDraggingProgress = progress
                            if let currentVideoItem = player?.currentItem {
                                let totalDuration = currentVideoItem.duration.seconds
                                
                                player?.seek(to: .init(seconds: totalDuration * progress, preferredTimescale: 1))
                                
                                if isPlaying {
                                    timeoutContols()
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                isSeeking = false
                            })
                            
                        })
                )
                .offset(x: progress * videoPlyerSize.width > 15 ? -15 : 0)
                .frame(width: 15, height: 15)
        }
    }
    
    func PlayBackControls() -> some View {
        HStack(spacing: 25) {
            Button {
                
            } label: {
                Image(systemName: "backward.end.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(.black.opacity(0.35))
                    }
            }
            .disabled(true)
            .opacity(0.6)
            
            Button {
                if isFinishedPlaying {
                    isFinishedPlaying = false
                    player?.seek(to: .zero)
                    progress = .zero
                    lastDraggingProgress = .zero
                }
                
                if isPlaying {
                    player?.pause()
                    if let timeoutTask {
                        timeoutTask.cancel()
                    }
                } else {
                    player?.play()
                    timeoutContols()
                }
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPlaying.toggle()
                }
            } label: {
                Image(systemName: isFinishedPlaying ? "arrow.clockwise" : (isPlaying ? "pause.fill" : "play.fill"))
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(.black.opacity(0.35))
                    }
            }
            .scaleEffect(1.2)
            
            Button {
                
            } label: {
                Image(systemName: "forward.end.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(.black.opacity(0.35))
                    }
            }
            .disabled(true)
            .opacity(0.6)
        }
        .opacity(showPlayerControls && !isDragging ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: showPlayerControls && !isDragging)
    }
    
    func timeoutContols() {
        if let timeoutTask {
            timeoutTask.cancel()
        }
        
        timeoutTask = .init(block: {
            withAnimation(.easeInOut(duration: 0.35)) {
                showPlayerControls = false
            }
        })
        
        if let timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: timeoutTask)
        }
    }
}

#Preview {
    VideoPlayerCustomContentView()
}

struct CustomVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = false
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
