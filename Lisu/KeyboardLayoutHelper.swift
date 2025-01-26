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
            ["ʼ", "ꓪ","ꓰ","ꓣ","ꓔ","ꓬ","ꓴ","ꓲ","ꓳ","ꓑ"],
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

    static func getKeyWidth(for key: String, totalWidth: CGFloat, rowKeys: [String], rowIndex: Int = 0) -> CGFloat {
        let maxKeysInRow = 10 // Maximum number of keys in any row
        let isLandscape = DeviceHelper.isLandscape()
        
        let widthPercentage: CGFloat = 0.99
        let maxWidth: CGFloat = isLandscape ? 900 : 400
        let usableWidth = min(totalWidth * widthPercentage, maxWidth)
        
        // Calculate regular key width
        let regularKeyWidth: CGFloat
        if isLandscape {
            let landscapeMaxKeys: CGFloat = 10
            regularKeyWidth = (usableWidth - (landscapeMaxKeys - 1) * KeyboardConstants.keySpacing) / landscapeMaxKeys
        } else {
            regularKeyWidth = (usableWidth - (CGFloat(maxKeysInRow - 1) * KeyboardConstants.keySpacing)) / CGFloat(maxKeysInRow)
        }
        
        // Calculate space key width based on remaining space in row
        if key == "Space" {
            let otherKeysWidth = rowKeys.reduce(0) { result, currentKey in
                if currentKey != "Space" {
                    switch currentKey {
                    case "Shift", "Unshift", "Backspace", "Return", "?123", "ꓐꓑꓒ", "=\\<":
                        return result + regularKeyWidth * (isLandscape ? 1.2 : 1.5) + KeyboardConstants.keySpacing
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
            return max(remainingWidth, regularKeyWidth * (isLandscape ? 4 : 2))
        }
        
        // Special key widths based on regular key width, orientation, and row
        switch key {
        case "Shift", "Unshift":
            let multiplier: CGFloat = rowIndex == 2 ? (isLandscape ? 1.2 : 1.2) : (isLandscape ? 1.2 : 1.5)
            return regularKeyWidth * multiplier + KeyboardConstants.keySpacing
        case "Backspace":
            let multiplier: CGFloat = rowIndex == 2 ? (isLandscape ? 1.2 : 1.2) : (isLandscape ? 1.2 : 1.5)
            return regularKeyWidth * multiplier + KeyboardConstants.keySpacing
        case "Return":
            return regularKeyWidth * (isLandscape ? 1.2 : 1.5) + KeyboardConstants.keySpacing
        case "?123", "ꓐꓑꓒ", "=\\<":
            let multiplier: CGFloat = rowIndex == 2 ? (isLandscape ? 1.2 : 1.2) : (isLandscape ? 1.2 : 1.5)
            return regularKeyWidth * multiplier + KeyboardConstants.keySpacing
        case "KeyboardChange":
            return regularKeyWidth
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
