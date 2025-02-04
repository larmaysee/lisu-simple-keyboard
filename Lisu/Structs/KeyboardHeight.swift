//
//  KeyboardHeight.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 28/01/2025.
//

import SwiftUI

struct KeyboardHeightEnvironment {
    private static var keyboardHeight: CGFloat = 0
    
    static func updateHeight(_ height: CGFloat) {
        keyboardHeight = height
    }
    
    static var currentHeight: CGFloat {
        keyboardHeight
    }
}

struct KeyboardHeightReader: ViewModifier {
    @State private var height: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: KeyboardHeightPreferenceKey.self, value: geometry.size.height)
            })
            .onPreferenceChange(KeyboardHeightPreferenceKey.self) { newHeight in
                KeyboardHeightEnvironment.updateHeight(newHeight)
                self.height = newHeight
            }
    }
}

