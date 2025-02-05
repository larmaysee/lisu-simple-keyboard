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
        GeometryReader { _ in
            Button(action: {}) {
                keyContent
                    .padding(DeviceHelper.isIPad ? KeyboardConstants.keyContentPadding * 2 : KeyboardConstants.keyContentPadding / 2)
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
            }
            .buttonStyle(KeyButtonStyle(isPressed: isPressed))
            .frame(
                maxWidth: .infinity,
                minHeight: getKeyButtonHeight(),
                maxHeight: getKeyButtonHeight()
            )
            .contentShape(Rectangle())
            .background(.gray.opacity(0.01))
            .modifier(TapGestureModifier(onTap: action))
        }
        .frame(maxWidth: .infinity)
    }
    
    /// Determines the content for the key (icon or text).
    @ViewBuilder
    private var keyContent: some View {
        if let systemImage = systemImageForKey(key) {
            Image(systemName: systemImage)
        } else {
            Text(textForKey(key))
        }
    }
    
    // MARK: - Key Height Calculation
    private func getKeyButtonHeight() -> CGFloat {
        DeviceHelper.isIPad ?
            DeviceHelper.isLandscape ?
        KeyboardConstants.iPadKeyButtonHeightLandscape: KeyboardConstants.iPadKeyButtonHeight
        : DeviceHelper.isLandscape ?
        KeyboardConstants.iOSKeyButtonHeightLandscape: KeyboardConstants.iOSKeyButtonHeight
    }
    
    /// Returns the system icon for special keys.
    private func systemImageForKey(_ key: String) -> String? {
        let keyIconMap: [String: String] = [
            SpecialKeys.backspace: "delete.left",
            SpecialKeys.return: "arrow.turn.down.left",
            SpecialKeys.keyboardChange: "globe",
            SpecialKeys.shift: "shift",
            SpecialKeys.shift2: "shift",
            SpecialKeys.unshift: capsLock ? "capslock.fill" : "shift.fill",
            SpecialKeys.unshift2: capsLock ? "capslock.fill" : "shift.fill"
        ]
        return keyIconMap[key]
    }
    
    /// Maps specific keys to alternate text representations.
    private func textForKey(_ key: String) -> String {
        let textOverrides: [String: String] = [
            SpecialKeys.numbers2: SpecialKeys.numbers,
            SpecialKeys.symbols2: SpecialKeys.symbols,
            SpecialKeys.bpd2: SpecialKeys.bpd
        ]
        return textOverrides[key] ?? key
    }
    
    /// Returns the background color based on theme.
    private var backgroundColor: Color {
        colorScheme == .dark ? configuration.darkBackground : configuration.lightBackground
    }

    /// Returns the foreground color based on theme.
    private var foregroundColor: Color {
        colorScheme == .dark ? configuration.darkForeground : configuration.lightForeground
    }

    /// Returns the border color based on theme.
    private var borderColor: Color {
        colorScheme == .dark ? configuration.darkBorder : configuration.lightBorder
    }
}
