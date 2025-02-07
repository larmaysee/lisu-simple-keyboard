//
//  TagGestureModifier.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 31/01/2025.
//

import SwiftUI

struct TapGestureModifier: ViewModifier {
    let onTap: () -> Void
    let onPress: () -> Void
    let onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in
                        onTap()
                        onRelease()
                    }
            )
    }
}
