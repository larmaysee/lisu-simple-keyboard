//
//  KeyboardLayoutHelper.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

struct KeyboardLayout {
    let rows: [[String]]
    
    static let defaultLayout = KeyboardLayout(
        rows: [
            ["Q", "ꓪ", "ꓰ", "ꓣ", "ꓔ", "ꓬ", "ꓴ", "ꓲ", "ꓳ", "ꓑ"],
            ["ꓮ", "ꓢ", "ꓓ", "ꓝ", "ꓖ", "ꓧ", "ꓙ", "ꓗ", "ꓡ"],
            ["shift", "ꓜ", "ꓫ", "ꓚ", "ꓦ", "ꓐ", "ꓠ", "ꓟ", "backspace"],
            ["123", "keyboardchange", "space", ".", "return"]
        ]
    )

    static let shiftedLayout = KeyboardLayout(
        rows: [
            ["'", "ꓼ", "ꓱ", "ꓤ", "ꓕ", "ꓻ", "ꓵ", "꓾", "ˍ", "ꓒ"],
            ["ꓯ", "ꓸꓼ", "ꓷ", "ꓞ", "ꓨ", "ꓺ", "ꓩ", "ꓘ", "ꓶ"],
            ["unshift", "ꓹ", ":", "ꓛ", "ꓥ", "ꓭ", "-", "=", "backspace"],
            ["123", "keyboardchange", "space", "?", "return"]
        ]
    )
    
    static let numberPadLayout = KeyboardLayout(
        rows: [
            ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
            ["/", "\"", "ꓹꓼ", "(", ")", "$", "&", "@", "!"],
            ["sym", "#", "\\", "=", "-", "+", "<", ">", "backspace"],
            ["Abc", "keyboardchange", "space", ",", "return"]
        ]
    )

    static let symbolPadLayout = KeyboardLayout(
        rows: [
            ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
            ["~", "`", "{", "}", "_", "-", ",", "|", "§"],
            ["123", "|", "~", "€", "£", "¥", "<", ">", "backspace"],
            ["Abc", "keyboardchange", "space", "ꓸ", "return"]
        ]
    )
    
    static func getCurrentLayout(isShifted: Bool, isNumberPad: Bool, isSymbolPad: Bool) -> KeyboardLayout {
        print("isShifted: \(isShifted), isNumberPad: \(isNumberPad), isSymbolPad: \(isSymbolPad)")
        
        if isSymbolPad { return symbolPadLayout }
        if isNumberPad { return numberPadLayout }
        if isShifted { return shiftedLayout }
        return defaultLayout
    }
}

enum KeyboardLayoutHelper {
    static func getKeyWidth(for key: String, totalWidth: CGFloat, rowKeys: [String]) -> CGFloat {
        // Calculate total spacing between keys
        let totalSpacing = (CGFloat(rowKeys.count + 1) * KeyboardConstants.keySpacing)
        
        // Available width after subtracting spacing
        let availableWidth = totalWidth - totalSpacing
        
        // Calculate base unit considering the extra spacers in row 3
        var totalUnits: CGFloat = 0
        
        for k in rowKeys {
            switch k {
            case "space":
                totalUnits += 5
            case "return", "shift", "unshift":
                totalUnits += 1.5
            case "backspace":
                totalUnits += 1.3
            case "keyboardchange", "123", "Abc", "sym":
                totalUnits += 1.2
            default:
                totalUnits += 1
            }
        }
        
        let baseUnit = availableWidth / totalUnits
        
        // Special key widths
        switch key {
        case "space":
            return baseUnit * 5
        case "return", "shift", "unshift":
            return baseUnit * 1.5
        case "backspace":
            return baseUnit * 1.3
        case "keyboardchange", "123", "Abc", "sym":
            return baseUnit * 1.2
        default:
            return baseUnit
        }
    }
    
    static func getKeyHeight(totalHeight: CGFloat) -> CGFloat {
        let isLandscape = DeviceHelper.isLandscape()
        
        // Calculate available height after padding
        let totalPadding = (KeyboardConstants.verticalPadding * 2) +
                          (CGFloat(KeyboardConstants.numberOfRows - 1) * KeyboardConstants.rowSpacing) +
                          (CGFloat(KeyboardConstants.numberOfRows) * KeyboardConstants.rowVerticalPadding)
        
        let availableHeight = totalHeight - totalPadding
        let baseHeight = availableHeight / CGFloat(KeyboardConstants.numberOfRows)
        
        // Set minimum and maximum heights based on device and orientation
        let minHeight: CGFloat = isLandscape ? 32 : 40
        let maxHeight: CGFloat = isLandscape ? 40 : 45
        
        return max(min(baseHeight, maxHeight), minHeight)
    }
}
