//
//  HalfModalCustom.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/07.
//

import SwiftUI

/// iOS16 Over using -> View.presentationDetents
/// public func presentationDetents(_ detents: Set<PresentationDetent>) -> some View
/// iOS 15 Half Sheet Modal - Bottom Sheet Drawer

struct HalfModalCustom: View {
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationView {
            CustomButton(title: "Show Half Modal") {
                showSheet.toggle()
            }
            .navigationTitle("Half Modal Sheet")
            .halfSheet(showSheet: $showSheet) {
                ZStack {
                    Color.red.ignoresSafeArea()
                    Text("TEST")
                }
            } onDismiss: {
                print("Dismissed")
            }
        }
    }
}

#Preview {
    HalfModalCustom()
}

extension View {
    func halfSheet<SheetView: View>(
        showSheet: Binding<Bool>,
        @ViewBuilder sheetView: @escaping () -> SheetView,
        onDismiss: @escaping () ->()) -> some View {
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(),
                                showSheet: showSheet,
                                onDismiss: onDismiss)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onDismiss: () -> ()
    
    let controlller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controlller.view.backgroundColor = .clear
        return controlller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }
    
    // on Dismiss
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onDismiss()
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        view.backgroundColor = .clear
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            
            // grab protion
            presentationController.prefersGrabberVisible = true
        }
    }
}
