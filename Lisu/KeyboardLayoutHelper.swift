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
            ["ʼ", "ꓼ","ꓱ","ꓤ","ꓕ","ꓻ","ꓵ","ꓹꓼ","ˍ","ꓒ"],
            ["ꓯ","ꓽ","ꓷ","ꓞ","ꓨ","ꓺ","ꓩ","ꓘ","ꓶ"],
            ["Unshift", "ꓹ","ꓸ","ꓛ","ꓥ","ꓭ","-","ꓸꓼ","Backspace"],
            ["?123","꓾","KeyboardChange", "Space", "꓿", "Return"]
        ]
    )
    
    static let numberPadLayout = KeyboardLayout(
        rows: [
            ["1","2","3","4","5","6","7","8","9","0"],
            ["@","#","$","_","&","-","+","(",")","/"],
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
        let maxKeysInRow = 10 // Maximum number of keys in any row
        let usableWidth = min(totalWidth * 0.98, 400) // Use 98% of width, max 400pts
        let regularKeyWidth = (usableWidth - (CGFloat(maxKeysInRow - 1) * KeyboardConstants.keySpacing)) / CGFloat(maxKeysInRow)
        
        // Calculate space key width based on remaining space in row
        if key == "Space" {
            let otherKeysWidth = rowKeys.reduce(0) { result, currentKey in
                if currentKey != "Space" {
                    switch currentKey {
                    case "Shift", "Unshift", "Backspace", "Return", "?123", "ꓐꓑꓒ", "=\\<":
                        return result + regularKeyWidth * 1.5 + KeyboardConstants.keySpacing
                    case "KeyboardChange":
                        return result + regularKeyWidth
                    default:
                        return result + regularKeyWidth
                    }
                }
                return result
            }
            let spacingWidth = CGFloat(rowKeys.count - 1) * KeyboardConstants.keySpacing
            let remainingWidth = usableWidth - otherKeysWidth - spacingWidth
            return max(remainingWidth, regularKeyWidth * 2) // Minimum width of 2 regular keys
        }
        
        // Special key widths based on regular key width
        switch key {
        case "Shift", "Unshift":
            return regularKeyWidth * 1.5 + KeyboardConstants.keySpacing // Width of 1.5 regular keys
        case "Backspace":
            return regularKeyWidth * 1.5 + KeyboardConstants.keySpacing // Width of 1.5 regular keys
        case "Return":
            return regularKeyWidth * 1.5 + KeyboardConstants.keySpacing // Width of 1.5 regular keys
        case "?123", "ꓐꓑꓒ", "=\\<":
            return regularKeyWidth * 1.5 + KeyboardConstants.keySpacing // Width of 1.5 regular keys
        case "KeyboardChange":
            return regularKeyWidth // Same as regular key
        default:
            return regularKeyWidth
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
