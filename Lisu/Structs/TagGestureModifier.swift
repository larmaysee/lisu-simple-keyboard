//
//  TagGestureModifier.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 31/01/2025.
//

import SwiftUI

struct TapGestureModifier: ViewModifier {
    let onTap: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture(count: 1)
                    .onEnded { _ in onTap() }
            )
    }
}
