//
//  KeyboardRowView.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 29/01/2025.
//

import SwiftUI

struct KeyboardRow: View {
    let keys: [String]
    let viewModel: KeyboardViewModel
    let isIPad: Bool
    let rowIndex: Int
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(
            alignment:.bottom,
            spacing: 0) {
            ForEach(keys, id: \.self) { key in
                KeyButton(
                    key: key,
                    capsLock: viewModel.capsLock,
                    isPressed: viewModel.pressedKey == key,
                    action: { viewModel.handleKeyPress(key) },
                    doubleTapAction: { viewModel.handleKeyPress(key, isDoubleTap: true) },
                    configuration: keyConfiguration(for: key)
                )
                .frame(
                    minWidth: getWidth(key: key, rowIndex: rowIndex),
                    maxWidth: getWidth(key: key, rowIndex: rowIndex),
                    maxHeight: DeviceHelper.isIPad ? KeyboardConstants.iPadKeyButtonHeight : KeyboardConstants.iOSKeyButtonHeight
                )
            }
        }
    }
        
    
    private func keyConfiguration(for key: String) -> KeyConfiguration {
        var config = KeyConfiguration.configuration(for: key, isIPad: isIPad)
        
        // iPad-specific adjustments
        if isIPad {
            switch key {
            case SpecialKeys.tab, SpecialKeys.undo, SpecialKeys.redo, SpecialKeys.bpd, SpecialKeys.symbols, SpecialKeys.numbers, SpecialKeys.keyboardChange,SpecialKeys.shift, SpecialKeys.unshift, SpecialKeys.english:
                config = config.with(font: .system(size: 16, weight: .medium), alignment: .bottomLeading)
            case SpecialKeys.backspace, SpecialKeys.return, SpecialKeys.shift2, SpecialKeys.unshift2, SpecialKeys.numbers2, SpecialKeys.symbols2, SpecialKeys.bpd2:
                config = config.with(font: .system(size: 16, weight: .medium), alignment: .bottomTrailing)
            default: break
            }
        } else {
            // iPhone-specific adjustments
            switch key {
            case SpecialKeys.space:
                config = config.with(font: .system(size: 16))
            case SpecialKeys.backspace, SpecialKeys.return:
                config = config.with(font: .system(size: 16, weight: .medium))
            case SpecialKeys.shift, SpecialKeys.unshift:
                config = config.with(font: .system(size: 16, weight: .medium))
            case SpecialKeys.bpd:
                config = config.with(font: .system(size: 16, weight: .medium))
            default: break
            }
        }
        
        return config
    }
    
    private func getWidth(key: String, rowIndex: Int) -> CGFloat? {
        return keyWidth(key: key, rowIndex: rowIndex)
    }
    
    private func keyWidth(key: String, rowIndex: Int) -> CGFloat? {
        
        print("screen width \(UIScreen.main.bounds.width)")
        print("is orientation portrait \(DeviceHelper.isLandscape)")
        
        struct KeyWidthMultipliers {
            let space: CGFloat
            let largeFunction: CGFloat
            let mediumFunction: CGFloat
            let smallFunction: CGFloat
        }
        
        /// Returns appropriate width multipliers for iPad or iPhone
        func getMultipliers() -> KeyWidthMultipliers {
            if isIPad {
                return KeyWidthMultipliers(
                    space: 0.4,
                    largeFunction: 2.5,
                    mediumFunction: 2.0,
                    smallFunction: 1.5
                )
            } else {
                return KeyWidthMultipliers(
                    space: 0.4,
                    largeFunction: 1.2,
                    mediumFunction: 1.1,
                    smallFunction: 1
                )
            }
        }
        
        let multipliers = getMultipliers()
        
        /// Default width based on iPad/iOS
        let defaultWidth = isIPad ? KeyboardConstants.iPadKeyContentHeight : KeyboardConstants.iOSKeyContentHeight
        
        switch (rowIndex, key) {
        
        // Space Key
        case (_, SpecialKeys.space):
            return multipliers.space * UIScreen.main.bounds.width

        // Small function keys (e.g., Tab)
        case (_, SpecialKeys.tab):
            return defaultWidth * multipliers.smallFunction

        // Medium function keys (e.g., English, Undo)
        case (_, SpecialKeys.english), (_, SpecialKeys.undo):
            return defaultWidth * multipliers.mediumFunction

        // Large function keys (e.g., Shift, Unshift, Redo in row 3)
        case (3, SpecialKeys.shift), (3, SpecialKeys.shift2),
             (3, SpecialKeys.unshift), (3, SpecialKeys.unshift2),
             (_, SpecialKeys.redo):
            return defaultWidth * multipliers.largeFunction

        // Return key (different for iPad/iOS)
        case (_, SpecialKeys.return):
            return isIPad
            ? KeyboardConstants.iPadKeyContentHeight * multipliers.mediumFunction
            : KeyboardConstants.iOSKeyContentHeight * multipliers.largeFunction

        // Small function keys (e.g., Shift, Unshift, Symbols)
        case (2, SpecialKeys.shift), (2, SpecialKeys.unshift), (_, SpecialKeys.symbols):
            return isIPad ? defaultWidth * multipliers.mediumFunction : defaultWidth * multipliers.smallFunction

        // Backspace key
        case (_, SpecialKeys.backspace):
            return isIPad
            ? KeyboardConstants.iPadKeyContentHeight * multipliers.smallFunction
            : KeyboardConstants.iOSKeyContentHeight * multipliers.smallFunction

        // Numbers & BPD keys
        case (_, SpecialKeys.numbers), (_, SpecialKeys.bpd):
            return isIPad ? defaultWidth * multipliers.mediumFunction :  defaultWidth * multipliers.smallFunction

        // Default case (No width specified)
        default:
            return nil
        }
    }
}

// MARK: - Key Configuration Extension
extension KeyConfiguration {
    func with(
        font: Font? = nil,
        minHeight: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        borderWidth: CGFloat? = nil,
        alignment: Alignment? =  nil
    ) -> KeyConfiguration {
        KeyConfiguration(
            font: font ?? self.font,
            minHeight: minHeight ?? self.minHeight,
            cornerRadius: cornerRadius ?? self.cornerRadius,
            borderWidth: borderWidth ?? self.borderWidth,
            darkBackground: self.darkBackground,
            lightBackground: self.lightBackground,
            darkForeground: self.darkForeground,
            lightForeground: self.lightForeground,
            darkBorder: self.darkBorder,
            lightBorder: self.lightBorder,
            alignment: alignment ?? self.alignment,
            keyPressedColor: self.keyPressedColor
        )
    }
}
