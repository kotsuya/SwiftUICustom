//
//  CustomNavLink.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/07/20.
//

import SwiftUI

// struct NavigationLink<Label, Destination> : View where Label : View, Destination : View
// init(destination: Destination, @ViewBuilder label: () -> Label)

struct CustomNavLink<Label: View, Destination: View>: View {
    let label: Label
    let destination: Destination
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(
            destination: CustomNavContainerView {
                destination
                    .navigationBarHidden(true)
            }) {
            label
        }
    }
}

#Preview {
    CustomNavBarView {
        CustomNavLink(destination: Text("Desti")) {
            Text("Click Me")
        }
    }
}
