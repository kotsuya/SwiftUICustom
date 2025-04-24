//
//  ChipsView.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/04/23.
//

import SwiftUI

let testTags: [String] = ["iOS", "SwiftUI", "macOS", "watchOS", "tvOS", "Xcode", "UIKit", "AppKit", "Cocoa", "Objective-C"]

struct ChipsViewContent: View {
    var body: some View {
        NavigationStack {
            VStack {
                ChipsView(tags: testTags) { tag, isSelected in
                    ChipCustomView(tag, isSelected: isSelected)
                } didChangeSelection: { selection in
                    print(selection)
                }
                .padding(15)
                .background(.gray.opacity(0.1), in: .rect(cornerRadius: 20))
            }
            .padding()
            .navigationTitle("Chips View")
        }
    }
    
    @ViewBuilder
    func ChipCustomView(_ tag: String, isSelected: Bool) -> some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.callout)
                .foregroundStyle(isSelected ? .white : Color.primary)
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            ZStack {
                Capsule()
                    .fill(.background)
                    .opacity(!isSelected ? 1 : 0)
                
                Capsule()
                    .fill(.green.gradient)
                    .opacity(isSelected ? 1 : 0)
            }
        }
    }
}

struct ChipsView<Content: View, Tag: Equatable>: View where Tag: Hashable {
    var spacing: CGFloat = 10
    var animation: Animation = .easeInOut(duration: 0.2)
    var tags: [Tag]
    @ViewBuilder var content: (Tag, Bool) -> Content
    var didChangeSelection: ([Tag]) -> ()
    
    @State private var selectedTags: [Tag] = []
    
    var body: some View {
        CustomChipLayout(spacing: spacing) {
            ForEach(tags, id:\.self) { tag in
                let selected = selectedTags.contains(tag)
                content(tag, selected)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(animation) {
                            if selected {
                                selectedTags.removeAll { $0 == tag }
                            } else {
                                selectedTags.append(tag)
                            }
                        }
                        
                        didChangeSelection(selectedTags)
                    }
            }
        }
    }
}

fileprivate struct CustomChipLayout: Layout {
    var spacing: CGFloat
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        return .init(width: width, height: maxHeight(proposal: proposal, subviews: subviews))
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        for subview in subviews {
            let fitSize = subview.sizeThatFits(proposal)
            
            if (origin.x + fitSize.width) > bounds.maxX {
                origin.x = bounds.minX
                origin.y += fitSize.height + spacing
            }
            
            subview.place(at: origin, proposal: proposal)
            origin.x += fitSize.width + spacing
        }
    }
    
    private func maxHeight(proposal: ProposedViewSize, subviews: Subviews) -> CGFloat {
        var origin: CGPoint = .zero
        
        for subview in subviews {
            let fitSize = subview.sizeThatFits(proposal)
            
            if (origin.x + fitSize.width) > (proposal.width ?? 0) {
                origin.x = 0
                origin.y += fitSize.height + spacing
            }
            
            origin.x += fitSize.width + spacing
            
            if subview == subviews.last {
                origin.y += fitSize.height
            }
        }
        
        return origin.y
    }
}

#Preview {
    ChipsViewContent()
}
