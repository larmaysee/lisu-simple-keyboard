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
    static func configuration(for key: String, isIPad: Bool) -> KeyConfiguration {
        switch key {
            case SpecialKeys.shift, SpecialKeys.shift2, SpecialKeys.unshift, SpecialKeys.unshift2, SpecialKeys.backspace, SpecialKeys.keyboardChange, SpecialKeys.numbers, SpecialKeys.numbers2, SpecialKeys.bpd,SpecialKeys.bpd2, SpecialKeys.undo, SpecialKeys.redo, SpecialKeys.tab, SpecialKeys.symbols,SpecialKeys.symbols2, SpecialKeys.english:
                return KeyConfiguration(
                    font: .system(size: isIPad ? 20 : 16, weight: .medium),
                    minHeight: getkeyContentHeight(),
                    cornerRadius: DeviceHelper.isIPad ?  KeyboardConstants.iPadKeyRadius : KeyboardConstants.iOSKeyRadius,
                    borderWidth: 0.5,
                    darkBackground: KeyboardConstants.darkSpecialKeyColor,
                    lightBackground: KeyboardConstants.lightSpecialKeyColor,
                    darkForeground: .white,
                    lightForeground: .primary,
                    darkBorder: .clear,
                    lightBorder: .gray.opacity(0.5),
                    alignment: .center
                )
            case SpecialKeys.space:
                return KeyConfiguration(
                    font: .system(size: isIPad ? 18 : 14),
                    minHeight: getkeyContentHeight(),
                    cornerRadius: DeviceHelper.isIPad ?  KeyboardConstants.iPadKeyRadius : KeyboardConstants.iOSKeyRadius,
                    borderWidth: 0.5,
                    darkBackground: KeyboardConstants.darkRegularKeyColor,
                    lightBackground: KeyboardConstants.lightRegularKeyColor,
                    darkForeground: .white,
                    lightForeground: .primary,
                    darkBorder: .clear,
                    lightBorder: .gray.opacity(0.3),
                    alignment: .center
                )
            default:
                return KeyConfiguration(
                    font: .system(
                        size: isIPad ? 24 : 22),
                    minHeight: getkeyContentHeight(),
                    cornerRadius: DeviceHelper.isIPad ?  KeyboardConstants.iPadKeyRadius : KeyboardConstants.iOSKeyRadius,
                    borderWidth: 0.5,
                    darkBackground: KeyboardConstants.darkRegularKeyColor,
                    lightBackground: KeyboardConstants.lightRegularKeyColor,
                    darkForeground: .white,
                    lightForeground: .primary,
                    darkBorder: .clear,
                    lightBorder: .gray.opacity(0.3),
                    alignment: .center
                )
        }
    }
    
    static func getkeyContentHeight() -> CGFloat {
        DeviceHelper.isIPad ?
        DeviceHelper.isLandscape ? KeyboardConstants.iPadKeyContentHeightLandscape : KeyboardConstants.iPadKeyContentHeight
        : DeviceHelper.isLandscape ? KeyboardConstants.iOSKeyContentHeightLandscape : KeyboardConstants.iOSKeyContentHeight
    }
    
    static func getKeyButtonWidth(screenWidth: CGFloat) -> CGFloat {
        DeviceHelper.isIPad ? screenWidth / KeyboardConstants.iPadMaxKeyPerRow : screenWidth / KeyboardConstants.iOSMaxKeyPerRow
    }
    
    static func getKeyContentWidth(screenWidth: CGFloat) -> CGFloat {
        return DeviceHelper.isIPad ? getKeyButtonWidth(screenWidth: screenWidth) - (KeyboardConstants.iPadHorizontalPadding * 2) :
        getKeyButtonWidth(screenWidth: screenWidth) - (KeyboardConstants.iOSHorizontalPadding * 2)
    }
}

struct KeyButtonStyle: ButtonStyle {
    let isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .contentShape(Rectangle())
    }
}
