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
    let onHeightChanged: (CGFloat) -> Void
    let keyboardHieght: CGFloat
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var orientationManager = OrientationManager()  // ✅ Add orientation manager

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(keys, id: \.self) { key in
                KeyButton(
                    key: key,
                    capsLock: viewModel.capsLock,
                    action: { viewModel.handleKeyPress(key) },
                    doubleTapAction: { viewModel.handleKeyPress(key, isDoubleTap: true) },
                    configuration: keyConfiguration(for: key),
                    viewModel: viewModel
                )
                .frame(
                    minWidth: getKeyButtonWidth(key: key, rowIndex: rowIndex),
                    maxWidth: getKeyButtonWidth(key: key, rowIndex: rowIndex),
                    maxHeight: getKeyButtonHeight()
                )
            }        
        }
        .onReceive(orientationManager.$isLandscape) { isLandscape in
            // Handle orientation change if needed
            print("Orientation changed: keyboardrow \(isLandscape ? "Landscape" : "Portrait")")
            onHeightChanged(keyboardHieght)
        }
    }
    
    private func getTestHeight() {
        let keyButtonhe = getKeyButtonHeight()
        print("Key Button Height: \(keyButtonhe)")
    }
    
    // MARK: - Key Height Calculation
    private func getKeyButtonHeight() -> CGFloat {
        DeviceHelper.isIPad ?
            DeviceHelper.isLandscape ?
        KeyboardConstants.iPadKeyButtonHeightLandscape: KeyboardConstants.iPadKeyButtonHeight
        : DeviceHelper.isLandscape ?
        KeyboardConstants.iOSKeyButtonHeightLandscape: KeyboardConstants.iOSKeyButtonHeight
    }
    
    // MARK: - Key Configuration
    private func keyConfiguration(for key: String) -> KeyConfiguration {
        var config = KeyConfiguration.configuration(for: key, isIPad: isIPad)
        
        // Define common configurations
        let mediumFont = Font.system(size: 16, weight: .medium)

        // iPad-specific adjustments
        if isIPad {
            let bottomLeadingKeys: Set<String> = [
                SpecialKeys.tab, SpecialKeys.undo, SpecialKeys.redo, SpecialKeys.bpd,
                SpecialKeys.symbols, SpecialKeys.numbers, SpecialKeys.keyboardChange,
                SpecialKeys.shift, SpecialKeys.unshift, SpecialKeys.english
            ]
            
            let bottomTrailingKeys: Set<String> = [
                SpecialKeys.backspace, SpecialKeys.return, SpecialKeys.shift2,
                SpecialKeys.unshift2, SpecialKeys.numbers2, SpecialKeys.symbols2, SpecialKeys.bpd2
            ]
            
            if bottomLeadingKeys.contains(key) {
                config = config.with(font: mediumFont, alignment: .bottomLeading)
            } else if bottomTrailingKeys.contains(key) {
                config = config.with(font: mediumFont, alignment: .bottomTrailing)
            }
        } else {
            // iPhone-specific adjustments
            let mediumWeightKeys: Set<String> = [
                SpecialKeys.backspace, SpecialKeys.return, SpecialKeys.shift,
                SpecialKeys.unshift, SpecialKeys.bpd
            ]
            
            if key == SpecialKeys.space {
                config = config.with(font: .system(size: 16))
            } else if mediumWeightKeys.contains(key) {
                config = config.with(font: mediumFont)
            }
        }
        
        return config
    }

    // MARK: - Key Width Calculation for iPad
    private func getKeyButtonWidth(key: String, rowIndex: Int) -> CGFloat? {
        
        print("Screen width: \(UIScreen.main.bounds.width)")
        print("Is landscape: \(DeviceHelper.isLandscape)")
        
        struct KeyWidthMultipliers {
            let space: CGFloat
            let largeFunction: CGFloat
            let mediumFunction: CGFloat
            let smallFunction: CGFloat
            
            static let iPadPortrait = KeyWidthMultipliers(space: 0.4, largeFunction: 2.0, mediumFunction: 1.5, smallFunction: 1.3)
            static let iPadLandscape = KeyWidthMultipliers(space: 0.4, largeFunction: 2.0, mediumFunction: 1.5, smallFunction: 1.3)
            
            static let iPhonePortrait = KeyWidthMultipliers(space: 0.4, largeFunction: 1.3, mediumFunction: 1.2, smallFunction: 1.0)
            static let iPhoneLandscape = KeyWidthMultipliers(space: 0.4, largeFunction: 1.3, mediumFunction: 1.2, smallFunction: 1.0)
        }
        
        let isLandscape = DeviceHelper.isLandscape
        let multipliers: KeyWidthMultipliers
        
        if isIPad {
            multipliers = isLandscape ? KeyWidthMultipliers.iPadLandscape : KeyWidthMultipliers.iPadPortrait
        } else {
            multipliers = isLandscape ? KeyWidthMultipliers.iPhoneLandscape : KeyWidthMultipliers.iPhonePortrait
        }
        
        let defaultWidth = KeyConfiguration.getKeyButtonWidth(screenWidth: UIScreen.main.bounds.width)
        
        /// Returns the computed width based on multiplier
        func calculateWidth(_ multiplier: CGFloat) -> CGFloat {
            return defaultWidth * multiplier
        }
        
        switch key {
            case SpecialKeys.space:
                return multipliers.space * UIScreen.main.bounds.width
                
            case SpecialKeys.tab:
                return calculateWidth(multipliers.smallFunction)
                
            case SpecialKeys.english, SpecialKeys.undo:
                return calculateWidth(multipliers.mediumFunction)
                
            case SpecialKeys.shift, SpecialKeys.shift2,
                 SpecialKeys.unshift, SpecialKeys.unshift2,
                 SpecialKeys.redo where rowIndex == 3:
                return calculateWidth(multipliers.largeFunction)
                
            case SpecialKeys.return:
                return isIPad
                ? calculateWidth(multipliers.mediumFunction)
                : calculateWidth(multipliers.mediumFunction)
                
            case SpecialKeys.shift,
                SpecialKeys.unshift,
                SpecialKeys.symbols,
                SpecialKeys.numbers
                where rowIndex == 2:
                return calculateWidth(multipliers.mediumFunction)
                
            case SpecialKeys.backspace:
                return calculateWidth(multipliers.mediumFunction)
                
            case SpecialKeys.numbers, SpecialKeys.bpd:
            return isIPad ? calculateWidth(multipliers.mediumFunction) : calculateWidth(multipliers.mediumFunction)
                
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
        alignment: Alignment? = nil
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
            alignment: alignment ?? self.alignment
        )
    }
}
