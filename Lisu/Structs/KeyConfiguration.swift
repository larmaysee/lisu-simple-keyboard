//
//  KeyButton.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 28/01/2025.
//

import SwiftUI

struct KeyConfiguration {
    let font: Font
    let minHeight: CGFloat
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let darkBackground: Color
    let lightBackground: Color
    let darkForeground: Color
    let lightForeground: Color
    let darkBorder: Color
    let lightBorder: Color
    let alignment: Alignment
    let keyPressedColor: Color
    
    static func configuration(for key: String, isIPad: Bool) -> KeyConfiguration {
        switch key {
        case SpecialKeys.shift, SpecialKeys.shift2, SpecialKeys.unshift, SpecialKeys.unshift2, SpecialKeys.backspace, SpecialKeys.keyboardChange, SpecialKeys.numbers, SpecialKeys.numbers2, SpecialKeys.bpd, SpecialKeys.undo, SpecialKeys.redo, SpecialKeys.tab, SpecialKeys.symbols,SpecialKeys.symbols2, SpecialKeys.english:
            return KeyConfiguration(
                font: .system(size: isIPad ? 20 : 16, weight: .medium),
                minHeight: isIPad ? KeyboardConstants.iPadKeyContentHeight : KeyboardConstants.iOSKeyContentHeight,
                cornerRadius: KeyboardConstants.keyRadius,
                borderWidth: 0.5,
                darkBackground: KeyboardConstants.darkSpecialKeyColor,
                lightBackground: KeyboardConstants.lightSpecialKeyColor,
                darkForeground: .white,
                lightForeground: .primary,
                darkBorder: .clear,
                lightBorder: .gray.opacity(0.5),
                alignment: .center,
                keyPressedColor: KeyboardConstants.keyPressedColor
            )
        case SpecialKeys.space:
            return KeyConfiguration(
                font: .system(size: isIPad ? 18 : 14),
                minHeight: isIPad ? KeyboardConstants.iPadKeyContentHeight : KeyboardConstants.iOSKeyContentHeight,
                cornerRadius: KeyboardConstants.keyRadius,
                borderWidth: 0.5,
                darkBackground: KeyboardConstants.darkRegularKeyColor,
                lightBackground: KeyboardConstants.lightRegularKeyColor,
                darkForeground: .white,
                lightForeground: .primary,
                darkBorder: .clear,
                lightBorder: .gray.opacity(0.3),
                alignment: .center,
                keyPressedColor: KeyboardConstants.keyPressedColor
            )
        default:
            return KeyConfiguration(
                font: .system(size: isIPad ? 24 : 20),
                minHeight: isIPad ? KeyboardConstants.iPadKeyContentHeight : KeyboardConstants.iOSKeyContentHeight,
                cornerRadius: KeyboardConstants.keyRadius,
                borderWidth: 0.5,
                darkBackground: KeyboardConstants.darkRegularKeyColor,
                lightBackground: KeyboardConstants.lightRegularKeyColor,
                darkForeground: .white,
                lightForeground: .primary,
                darkBorder: .clear,
                lightBorder: .gray.opacity(0.3),
                alignment: .center,
                keyPressedColor: KeyboardConstants.keyPressedColor
            )
        }
    }
}

struct KeyButtonStyle: ButtonStyle {
    let isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(isPressed ? KeyboardConstants.keyPressedColor : .clear)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .contentShape(Rectangle())
    }
}
