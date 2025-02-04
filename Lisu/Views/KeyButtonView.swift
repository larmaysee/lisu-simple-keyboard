//
//  KeyButtonView.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 28/01/2025.
//

import SwiftUI

struct KeyButton: View {
    let key: String
    let capsLock: Bool
    let isPressed: Bool
    let action: () -> Void
    let doubleTapAction: () -> Void
    let configuration: KeyConfiguration
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {}) {
                keyContent
                    .padding(
                        DeviceHelper.isIPad ? KeyboardConstants.keyContentPadding * 2 : KeyboardConstants.keyContentPadding / 2
                    )
                    .font(configuration.font)
                    .frame(maxWidth: .infinity, minHeight: configuration.minHeight, alignment: configuration.alignment)
                    .background(backgroundColor)
                    .foregroundColor(foregroundColor)
                    .cornerRadius(configuration.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: configuration.cornerRadius)
                            .stroke(borderColor, lineWidth: configuration.borderWidth)
                    )
                    .padding(.horizontal, DeviceHelper.isIPad ? KeyboardConstants.iPadHorizontalPadding : KeyboardConstants.iOSHorizontalPadding)
//                    .modifier(TapModifier(
//                        singleTapAction: action,
//                        doubleTapAction: doubleTapAction,
//                        isShiftKey: key == SpecialKeys.shift || key == SpecialKeys.shift2
//                    ))
            }
            .buttonStyle(KeyButtonStyle(isPressed: isPressed))
            .frame(
                maxWidth: .infinity,
                minHeight: DeviceHelper.isIPad ?  KeyboardConstants.iPadKeyButtonHeight : KeyboardConstants.iOSKeyButtonHeight,
                maxHeight: DeviceHelper.isIPad ?  KeyboardConstants.iPadKeyButtonHeight : KeyboardConstants.iOSKeyButtonHeight
            )
            .contentShape(Rectangle())
            .background(.gray.opacity(0.01))
            .modifier(TapGestureModifier(
                onTap: {
                    action()
                }
            ))
        }
        .frame(maxWidth: .infinity)
    }
    
    /// Returns the appropriate icon or text for the key
    @ViewBuilder
    private var keyContent: some View {
        if let systemImage = systemImageForKey(key) {
            Image(systemName: systemImage)
        } else {
            Text(textForKey(key))
        }
    }
    
    /// Returns the system icon name for special keys
    private func systemImageForKey(_ key: String) -> String? {
        switch key {
        case SpecialKeys.backspace: return "delete.left"
        case SpecialKeys.return: return "arrow.turn.down.left"
        case SpecialKeys.keyboardChange: return "globe"
        case SpecialKeys.shift, SpecialKeys.shift2: return "shift"
        case SpecialKeys.unshift, SpecialKeys.unshift2:
            return capsLock ? "capslock.fill" : "shift.fill"
        default: return nil
        }
    }
    
    /// Returns the appropriate text for keys
    private func textForKey(_ key: String) -> String {
        switch key {
        case SpecialKeys.numbers2: return SpecialKeys.numbers
        case SpecialKeys.symbols2: return SpecialKeys.symbols
        case SpecialKeys.bpd2: return SpecialKeys.bpd
        default: return key
        }
    }
    
    /// Returns the background color based on the theme
    private var backgroundColor: Color {
        colorScheme == .dark ? configuration.darkBackground : configuration.lightBackground
    }
    
    /// Returns the foreground color based on the theme
    private var foregroundColor: Color {
        colorScheme == .dark ? configuration.darkForeground : configuration.lightForeground
    }
    
    /// Returns the border color based on the theme
    private var borderColor: Color {
        colorScheme == .dark ? configuration.darkBorder : configuration.lightBorder
    }
}
