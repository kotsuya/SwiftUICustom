//
//  AlertCustom.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/08/01.
//

import SwiftUI

struct AlertCustom: View {
    @State private var isNativeAlert: Bool = false
    @State private var password: String = ""
    @State private var isHUD: Bool = false
    @State private var isCustomAlert: Bool = false
    @State private var isCustomDialog: Bool = false
    
    @State private var showSheet: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                Button(action: {
                    alertView()
                }, label: {
                    Text("Native Alert with TextField")
                })
                
                if !password.isEmpty {
                    Text(password)
                        .fontWeight(.bold)
                }
                
                Button(action: {
                    withAnimation {
                        isHUD.toggle()
                    }
                }, label: {
                    Text("HUD Progress View")
                })
                
                Button(action: {
                    withAnimation {
                        isCustomAlert.toggle()
                    }
                }, label: {
                    Text("Custom Alert")
                })
                
                Button(action: {
                    withAnimation {
                        isCustomDialog.toggle()
                    }
                }, label: {
                    Text("Custom Dialog")
                })
                
                Divider()
                
                Button {
                    showSheet.toggle()
                } label: {
                    Text("Sheet")
                }
                .sheet(isPresented: $showSheet, content: {
                    SheetView()
                })
            }
            
            if isCustomAlert {
                CustomAlert(isShow: $isCustomAlert, title: "Title", message: "MessageMessageMessageMessageMessageMessageMessageMessageMessage")
            }
            
            if isHUD {
                HUDProgressView(isShow: $isHUD, placeholder: "Please Wait")
            }
            
            if isCustomDialog {
                CustomDialog(isShow: $isCustomDialog, title: "Title", message: "MessageMessageMessageMessageMessageMessageMessageMessageMessage", buttonTitle: "Button Title") {
                    
                }
            }
        }
    }
    
    func alertView() {
        let alert = UIAlertController(title: "Login", message: "Please enter your Password", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Password"
        }
        
        let login = UIAlertAction(title: "Login", style: .default) { _ in
            password = alert.textFields![0].text ?? ""
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
                
        alert.addAction(cancel)
        alert.addAction(login)
        
        rootVC?.present(alert, animated: true)
    }
}

struct HUDProgressView: View {
    @Binding var isShow: Bool
    @State var animate: Bool = false
    var placeholder: String
    
    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .stroke(AngularGradient.init(gradient: Gradient(colors: [Color.primary, Color.primary.opacity(0)]), center: .center))
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: animate ? 360 : 0))
            
            Text(placeholder)
                .fontWeight(.bold)
        }
        .padding(.all, 32)
        .background(BlurView())
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.35)
                .onTapGesture {
                    withAnimation {
                        isShow.toggle()
                    }
                }
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                animate.toggle()
            }
        }
        .ignoresSafeArea()
    }
}

struct CustomAlert: View {
    @Binding var isShow: Bool
    var title: String
    var message: String
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            VStack(spacing: 20) {
                Image(systemName: "trophy.fill")
                    .resizable()
                    .frame(width: 160, height: 160)
                    .foregroundStyle(.purple)
                    .padding(.top, 16)
                
                Text(title)
                    .font(.title)
                    .foregroundStyle(.pink)
                
                Text(message)
                
                Button(action: {
                    
                }, label: {
                    Text("Back To Top")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 32)
                        .background(.pink)
                        .clipShape(Capsule())
                })
                .padding(.vertical, 16)
            }
            .padding()
            .frame(width: screenWidth - 40)
            .background(BlurView())
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            Button(action: {
                withAnimation {
                    isShow.toggle()
                }
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.purple)
                    .padding()
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.35))
    }
}

struct CustomDialog: View {
    @Binding var isShow: Bool
    let title: String
    let message: String
    let buttonTitle: String
    let isAnimation: Bool
    let action: () -> ()
    
    init(
        isShow: Binding<Bool>,
        title: String,
        message: String,
        buttonTitle: String,
        isAnimation: Bool = true,
        action: @escaping () -> ()
    ) {
        self._isShow = isShow
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.isAnimation = isAnimation
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.title)
                .bold()
                .padding()
            
            Text(message)
                .font(.body)
                .padding(.horizontal, 20)
            
            Button(action: {
                action()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.red)
                    
                    Text(buttonTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding()                        
                }
                .padding(.all, 20)
            })
        }
        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        .padding()
        .background(BlurView())
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        if isAnimation {
                            withAnimation {
                                isShow.toggle()
                            }
                        } else {
                            withoutAnimation {
                                isShow.toggle()
                            }
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.black)
                    })
                }
                Spacer()
            }
            .padding()
        }
        .shadow(radius: 10)
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.35))
    }
}

struct BlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isHUD: Bool = false
    @State private var isCustomAlert: Bool = false
    @State private var isCustomDialog: Bool = false
    @State private var isAlert: Bool = false
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                HStack {
                    VStack(alignment: .trailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Button(action: {
                    withAnimation {
                        isHUD.toggle()
                    }
                }, label: {
                    Text("HUD Progress View")
                })
                
                Button(action: {
                    isAlert.toggle()
                }, label: {
                    Text("Alert")
                })
                .alert("Alert", isPresented: $isAlert) {
                    Button("Cancel", role: .destructive) { }
                    Button("OK", role: .cancel) { }
                }
                
                Button(action: {
                    withAnimation {
                        isCustomAlert.toggle()
                    }
                }, label: {
                    Text("Custom Alert")
                })
                
                Button(action: {
                    withAnimation {
                        isCustomDialog.toggle()
                    }
                }, label: {
                    Text("Custom Dialog")
                })
                
                
                Button(action: {
                    withoutAnimation {
                        isPresented.toggle()
                    }
                }, label: {
                    Text("using fullScreenCover")
                })
                .fullScreenCover(isPresented: $isPresented) {
                    CustomDialog(isShow: $isPresented, title: "Title", message: "MessageMessageMessageMessageMessageMessageMessageMessageMessage", buttonTitle: "Button Title", isAnimation: false) {
                    }
                }
            }
            
            if isHUD {
                HUDProgressView(isShow: $isHUD, placeholder: "Please Wait")
            }
            
            if isCustomAlert {
                CustomAlert(isShow: $isCustomAlert, title: "Title", message: "MessageMessageMessageMessageMessageMessageMessageMessageMessage")
            }
            
            if isCustomDialog {
                CustomDialog(isShow: $isCustomDialog, title: "Title", message: "MessageMessageMessageMessageMessageMessageMessageMessageMessage", buttonTitle: "Button Title") {
                    
                }
            }
        }
    }
}

#Preview {
    AlertCustom()
}

extension View {
    // MEMO: replace using: UIView.setAnimationsEnabled(false)
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}
