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
    let action: () -> Void
    let doubleTapAction: () -> Void
    let configuration: KeyConfiguration
    let viewModel: KeyboardViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressedState: Bool = false  // ✅ Track press state locally
    @ObservedObject var orientationManager = OrientationManager()  // ✅ Add orientation manager

    var body: some View {
        GeometryReader { _ in
            Button(action: {
            }) {
                keyContent
                    .padding(DeviceHelper.isIPad ? KeyboardConstants.keyContentPadding * 2 : KeyboardConstants.keyContentPadding / 2)
                    .font(configuration.font)
                    .frame(maxWidth: .infinity, minHeight: configuration.minHeight, alignment: configuration.alignment)
                    .background(isPressedState ? pressedBackgroundColor : backgroundColor) // ✅ Change background when pressed
                    .foregroundColor(isPressedState ? pressedForegroundColor : foregroundColor) // ✅ Change text color when pressed
                    .cornerRadius(configuration.cornerRadius)
                    .shadow(color: Color.black.opacity(0.2), radius: 0.5, x: 0, y: 1.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: configuration.cornerRadius)
                            .stroke(borderColor, lineWidth: configuration.borderWidth)
                    )
                    .padding(.horizontal, DeviceHelper.isIPad ? KeyboardConstants.iPadHorizontalPadding : KeyboardConstants.iOSHorizontalPadding)
            }
            .buttonStyle(KeyButtonStyle(isPressed: isPressedState))
            .frame(
                maxWidth: .infinity,
                minHeight: getKeyButtonHeight(),
                maxHeight: getKeyButtonHeight()
            )
            .contentShape(Rectangle())
            .background(.gray.opacity(0.01))
            .modifier(TapGestureModifier(
                onTap: action,
                onPress: {
                    isPressedState = true  // ✅ Set to true when pressed
                    viewModel.onPressed(key)
                },
                onRelease: {
                    isPressedState = false  // ✅ Set to false when released
                    viewModel.onReleased()
                }
            ))
            .onReceive(orientationManager.$isLandscape) { isLandscape in
                // Handle orientation change if needed
                print("Orientation changed: \(isLandscape ? "Landscape" : "Portrait")")
            }
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

    private func getKeyButtonHeight() -> CGFloat {
        DeviceHelper.isIPad ?
            DeviceHelper.isLandscape ?
        KeyboardConstants.iPadKeyButtonHeightLandscape: KeyboardConstants.iPadKeyButtonHeight
        : DeviceHelper.isLandscape ?
        KeyboardConstants.iOSKeyButtonHeightLandscape: KeyboardConstants.iOSKeyButtonHeight
    }

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

    private func textForKey(_ key: String) -> String {
        let textOverrides: [String: String] = [
            SpecialKeys.numbers2: SpecialKeys.numbers,
            SpecialKeys.symbols2: SpecialKeys.symbols,
            SpecialKeys.bpd2: SpecialKeys.bpd
        ]
        return textOverrides[key] ?? key
    }

    private var pressedBackgroundColor: Color {
        colorScheme == .dark ? KeyboardConstants.lightRegularKeyColor : KeyboardConstants.darkRegularKeyColor
    }

    private var pressedForegroundColor: Color {
        colorScheme == .dark ? configuration.lightForeground : configuration.darkForeground
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? configuration.darkBackground : configuration.lightBackground
    }

    private var foregroundColor: Color {
        colorScheme == .dark ? configuration.darkForeground : configuration.lightForeground
    }

    private var borderColor: Color {
        colorScheme == .dark ? configuration.darkBorder : configuration.lightBorder
    }
}
