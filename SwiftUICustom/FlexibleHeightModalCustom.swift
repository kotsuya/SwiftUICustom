//
//  FlexibleHeightModalCustom.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/07.
//

import SwiftUI

struct FlexibleHeightModalCustom: View {
    @State private var isShowModal: Bool = false
    
    var body: some View {
        ZStack {
            CustomButton(title: "Show Modal") {
                isShowModal.toggle()
            }
            
            FlexibleModalView(isShowModal: $isShowModal)
        }
    }
}

#Preview {
    FlexibleHeightModalCustom()
}

struct FlexibleModalView: View {
    @Binding var isShowModal: Bool
    @State private var isDragging: Bool = true
    
    @State private var currentHeight: CGFloat = 400
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.9
    
    let startOpacity: Double = 0.4
    let endOpacity: Double = 0.8
    
    var dragPercentage: Double {
        let res = Double((currentHeight - minHeight) / (maxHeight - minHeight))
        return max(0, min(1, res))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowModal {
                Color.black.opacity(startOpacity + (endOpacity-startOpacity) * dragPercentage)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowModal = false
                    }
                
                contentView
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, 
               maxHeight: .infinity,
               alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowModal)
    }
    
    var contentView: some View {
        VStack {
            // grabber
            ZStack {
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            .gesture(dragGesture)
            
            ZStack {
                VStack {
                    Text("Test")
                }
            }
            
            Spacer()
        }
        .frame(height: currentHeight)
        .frame(maxWidth: .infinity)
        .background(
            // roundedCorners only on top
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                Rectangle()
                    .frame(height: currentHeight / 2)
            }
            .foregroundStyle(Color.white)
        )
        .animation(isDragging ? nil : .easeInOut(duration: 0.45), value: isDragging)
        .onDisappear {
            currentHeight = minHeight
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                if !isDragging {
                    isDragging = true
                }
                let dragAmount = value.translation.height - prevDragTranslation.height
                if currentHeight > maxHeight || currentHeight < minHeight {
                    currentHeight -= dragAmount / 6
                } else {
                    currentHeight -= dragAmount
                }
                
                prevDragTranslation = value.translation
            }
            .onEnded { value in
                prevDragTranslation = .zero
                isDragging = false
                if currentHeight > maxHeight {
                    currentHeight = maxHeight
                } else if currentHeight < minHeight {
                    currentHeight = minHeight
                }
            }
    }
}
