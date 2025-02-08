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
    let rowIndex: Int
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressedState: Bool = false  // ✅ Track press state locally
    @State private var backspaceTimer: Timer?
    @ObservedObject var orientationManager = OrientationManager()  // ✅ Add orientation manager

    var body: some View {
        GeometryReader { _ in
            Button(action: action) {
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
                    .padding(
                        .horizontal,getPadding(rowIndex: rowIndex)
                    )
            }
            .buttonStyle(KeyButtonStyle(isPressed: isPressedState))
            .frame(
                maxWidth: .infinity,
                minHeight: getKeyButtonHeight(),
                maxHeight: getKeyButtonHeight()
            )
            .contentShape(Rectangle())
            .background(.gray.opacity(0.001))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressedState {
                            isPressedState = true
                            if key == SpecialKeys.backspace {
                                startBackspaceTimer()
                            }
                        }
                    }
                    .onEnded { _ in
                        if isPressedState {
                            isPressedState = false
                            stopBackspaceTimer()
                        }
                    }
            )
            .onDisappear {
                stopBackspaceTimer()
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

    private func getPadding (rowIndex: Int) -> CGFloat {
        DeviceHelper.isIPad ? KeyboardConstants.keyContentPadding : KeyboardConstants.keyContentPadding / 2
    }

    private func startBackspaceTimer() {
        backspaceTimer?.invalidate()
        backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            action()
        }
    }
    
    private func stopBackspaceTimer() {
        backspaceTimer?.invalidate()
        backspaceTimer = nil
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
