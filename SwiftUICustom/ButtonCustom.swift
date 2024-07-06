//
//  CustomButton.swift
//  SwiftUICustom
//
//  Created by Yoo on 2024/07/06.
//

import SwiftUI

struct ButtonCustom: View {
    var body: some View {
        VStack(spacing: 20) {
            CustomButton(title: "Simple Button") {
                print("Simple Button")
            }
            
            CustomButton(title: "Border Button",
                         isBorder: true,
                         borderWidth: 5,
                         backgroundColor: Color.white,
                         foregroundColor: Color.green,
                         pressedBgColor: Color.red,
                         pressedFgColor: Color.orange) {
                print("Border Button")
            }
            
            CustomButton(title: "Normal Button",
                         backgroundColor: Color.yellow) {
                print("Normal Button")
            }
        }
    }
}

#Preview {
    ButtonCustom()
}

struct CustomButtonStyle: ButtonStyle {
    
    let backgroundColor: Color
    let foregroundColor: Color
    let pressedBgColor: Color
    let pressedFgColor: Color
    let isDisabled: Bool
    let isBorder: Bool
    let borderWidth: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        let currentForegroundColor = isDisabled || configuration.isPressed ? pressedFgColor : foregroundColor
        return configuration.label
            .foregroundColor(currentForegroundColor)
            .background(isDisabled || configuration.isPressed ? pressedBgColor : backgroundColor)
            .clipShape(Capsule())
            .overlay {
                if isBorder {
                    Capsule()
                        .stroke(currentForegroundColor, lineWidth: borderWidth)
                }
            }
            .font(Font.system(size: 19, weight: .semibold))
    }
}

struct CustomButton: View {
    
    var backgroundColor: Color
    var foregroundColor: Color
    
    var pressedBgColor: Color
    var pressedFgColor: Color
    
    private let title: String
    private let action: () -> Void
    private let disabled: Bool
    private let isBorder: Bool
    private let borderWidth: CGFloat
    private let width: CGFloat
    private let height: CGFloat
    
    init(title: String,
         disabled: Bool = false,
         width: CGFloat = Const.buttonWidth,
         height: CGFloat = Const.buttonHeight,
         isBorder: Bool = false,
         borderWidth: CGFloat = 0.0,
         backgroundColor: Color = Color.green,
         foregroundColor: Color = Color.white,
         pressedBgColor: Color = Color.gray,
         pressedFgColor: Color = Color.cyan,
         action: @escaping () -> Void) {
        self.title = title
        self.disabled = disabled
        self.width = width
        self.height = height
        self.isBorder = isBorder
        self.borderWidth = borderWidth
        
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        
        self.pressedBgColor = pressedBgColor
        self.pressedFgColor = pressedFgColor
        
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth:.infinity, 
                       maxHeight:.infinity)
        }
        .buttonStyle(CustomButtonStyle(backgroundColor: backgroundColor,
                                       foregroundColor: foregroundColor,
                                       pressedBgColor: pressedBgColor,
                                       pressedFgColor: pressedFgColor,
                                       isDisabled: disabled,
                                       isBorder: isBorder,
                                       borderWidth: borderWidth))
        .disabled(disabled)
        .frame(width: width - borderWidth, height: height - borderWidth)
    }
}
