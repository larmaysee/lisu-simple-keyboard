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
            ["'", "ꓪ","ꓰ","ꓣ","ꓔ","ꓬ","ꓴ","ꓲ","ꓳ","ꓑ"],
            ["ꓮ","ꓢ","ꓓ","ꓝ","ꓖ","ꓧ","ꓙ","ꓗ","ꓡ"],
            ["Shift", "ꓜ","ꓫ","ꓚ","ꓦ","ꓐ","ꓠ","ꓟ","Backspace"],
            ["?123","꓾","KeyboardChange", "Space", "꓿", "Return"]
        ]
    )

    static let shiftedLayout = KeyboardLayout(
        rows: [
            ["ʼ", "ꓼ","ꓱ","ꓤ","ꓕ","ꓻ","ꓵ","ˍ","ꓒ"],
            ["ꓯ","ꓽ","ꓷ","ꓞ","ꓨ","ꓺ","ꓩ","ꓘ","ꓶ"],
            ["Unshift", "ꓹ","ꓸ","ꓛ","ꓥ","ꓭ","-","ꓸꓼ","Backspace"],
            ["?123","꓾","KeyboardChange", "Space", "꓿", "Return"]
        ]
    )
    
    static let numberPadLayout = KeyboardLayout(
        rows: [
            ["1","2","3","4","5","6","7","8","9","0"],
            ["@","'","#","$","_","&","-","+","(",")","/"],
            ["=\\<","*","\"","\'",":",";","!","?", "Backspace"],
            ["ꓐꓑꓒ",",", "Space", ".", "Return"]
        ]
    )

    static let symbolPadLayout = KeyboardLayout(
        rows: [
            ["~","`","|","•","√","π","÷","×","§","∆"],
            ["£","¢","€","¥","^","°","=","{","}","\\"],
            ["?123","%","©","®","™","✓","[","]","Backspace"],
            ["ꓐꓑꓒ","<","Space", ">", "Return"]
        ]
    )
    
    static func getCurrentLayout(isShifted: Bool, isNumberPad: Bool, isSymbolPad: Bool) -> KeyboardLayout {        
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
            case "Space":
                totalUnits += 5
            case "Return", "Shift", "Unshift":
                totalUnits += 1.5
            case "Backspace":
                totalUnits += 1.3
            case "Keyboardchange", "123", "Abc", "Sym":
                totalUnits += 1.2
            default:
                totalUnits += 1
            }
        }
        
        let baseUnit = availableWidth / totalUnits
        
        // Special key widths
        switch key {
        case "Space":
            return baseUnit * 5
        case "Return", "Shift", "Unshift":
            return baseUnit * 1.5
        case "Backspace":
            return baseUnit * 1.3
        case "Keyboardchange", "?123", "ꓐꓑꓒ", "=\\<":
            return baseUnit * 1.2
        default:
            return baseUnit
        }
    }
    
    static func getKeyHeight(totalHeight: CGFloat) -> CGFloat {
        let isLandscape = DeviceHelper.isLandscape()
        
        // Calculate available height after padding
        let totalPadding = (KeyboardConstants.verticalPadding * 2) +
                          (CGFloat(KeyboardConstants.numberOfRows) * KeyboardConstants.rowSpacing) +
                          (CGFloat(KeyboardConstants.numberOfRows) * KeyboardConstants.rowVerticalPadding)
        
        let availableHeight = totalHeight - totalPadding
        let baseHeight = availableHeight / CGFloat(KeyboardConstants.numberOfRows)
        
        // Set minimum and maximum heights based on device and orientation
        let minHeight: CGFloat = isLandscape ? 32 : 38
        let maxHeight: CGFloat = isLandscape ? 38 : 40
        
        return max(min(baseHeight, maxHeight), minHeight)
    }
}
