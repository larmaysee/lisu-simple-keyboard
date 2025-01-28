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
            ["ꓐꓑꓒ",",","KeyboardChange", "Space", ".", "Return"]
        ]
    )

    static let symbolPadLayout = KeyboardLayout(
        rows: [
            ["~","`","|","•","√","π","÷","×","§","∆"],
            ["£","¢","€","¥","^","°","=","{","}","\\"],
            ["?123","%","©","®","™","✓","[","]","Backspace"],
            ["ꓐꓑꓒ","<","KeyboardChange","Space", ">", "Return"]
        ]
    )
    
    static let ipadKeyboardLayout = KeyboardLayout(
        rows: [
            ["`","1","2","3","4","5","6","7","8","9","0", "Backspace"],
            ["Tab","ʼ", "ꓪ","ꓰ","ꓣ","ꓔ","ꓬ","ꓴ","ꓲ","ꓳ","ꓑ","[","]", "\\"],
            ["English","ꓮ","ꓢ","ꓓ","ꓝ","ꓖ","ꓧ","ꓙ","ꓗ","ꓡ","ꓼ","'", "Return"],
            ["Shift", "ꓜ","ꓫ","ꓚ","ꓦ","ꓐ","ꓠ","ꓟ","ꓹ","ꓸ","/","Shift"],
            ["?123","꓾","KeyboardChange", "Space", "꓿", "Return"]
        ]
    )

    static let ipadShiftedLayout = KeyboardLayout(
        rows: [
            ["~","!","@","#","$","%","^","&","*","(",")", "Backspace"],
            ["Tab","ʼ", "ꓼ","ꓱ","ꓤ","ꓕ","ꓻ","ꓵ","ꓹꓼ","ˍ","ꓒ","{","}", "|"],
            ["English","ꓯ","•","ꓷ","ꓞ","ꓨ","ꓺ","ꓩ","ꓘ","ꓶ","ꓽ","\"", "Return"],
            ["Unshift","“","”","ꓛ","ꓥ","ꓭ","-","ꓸꓼ", "ꓹ","ꓸ","?","Unshift"],
            ["?123","꓾","KeyboardChange", "Space", "꓿", "Return"]
        ]
    )

    static let ipadNumberPadLayout = KeyboardLayout(
        rows: [
            ["`","1","2","3","4","5","6","7","8","9","0","<", ">", "Backspace"],
            ["Tab","[","]","{","}","#","%","^","*","+","=", "\\","|", "~"],
            ["Undo","-","/",":",";","(",")","$","&","@","£","¥", "Return"],
            ["Redo","…",".",",","?","!","'","\"","_","€","Backspace"],
            ["ꓐꓑꓒ","π","KeyboardChange", "Space", ".", "Return"]
        ]
    )

    static func getCurrentLayout(isShifted: Bool, isNumberPad: Bool, isSymbolPad: Bool) -> KeyboardLayout {        
        if isSymbolPad { return symbolPadLayout }
        if isNumberPad { return numberPadLayout }
        if isShifted { return shiftedLayout }
        return defaultLayout
    }


    static func getIpadLayout(
        isShifted: Bool,
        isNumberPad: Bool
    ) -> KeyboardLayout {
        if isNumberPad { return ipadNumberPadLayout }
        if isShifted { return ipadShiftedLayout }
        return ipadKeyboardLayout
    }
}

enum KeyboardLayoutHelper {
    static let maxKeysInRow = 10 // Maximum number of keys in any row
    static func getRegularKeyWidth(totalWidth: CGFloat) -> CGFloat {
        let isLandscape = DeviceHelper.isLandscape()
        
        let widthPercentage: CGFloat = 1
        let maxWidth: CGFloat = isLandscape ? 900 : 400
        let usableWidth = totalWidth * widthPercentage
        
        // Calculate regular key width
        let regularKeyWidth: CGFloat
        if isLandscape {
            let landscapeMaxKeys: CGFloat = 10
            regularKeyWidth = (usableWidth - (landscapeMaxKeys - 1) * KeyboardConstants.keySpacing) / landscapeMaxKeys
        } else {
            regularKeyWidth = (usableWidth - (CGFloat(maxKeysInRow - 1) * KeyboardConstants.keySpacing)) / CGFloat(maxKeysInRow)
        }
        
        return regularKeyWidth
    }
    
    static func getKeyWidth(for key: String, totalWidth: CGFloat, rowKeys: [String], rowIndex: Int) -> CGFloat {
        // Special handling for 4th row
        if rowIndex == 3 {
            let totalSpacing = KeyboardConstants.keySpacing * CGFloat(rowKeys.count + 1) // Add extra spacing for edges
            let usableWidth = totalWidth - totalSpacing
            let remainingKeys = CGFloat(rowKeys.count - 1)
            
            if key == "Space" {
                // Space takes 40% of usable width
                return usableWidth * 0.4
            } else {
                // Other keys share the remaining 60% equally
                let remainingWidth = usableWidth * 0.6
                return (remainingWidth / remainingKeys)
            }
        }
        
        // Handle other rows as before
        let regularKeyWidth = getRegularKeyWidth(totalWidth: totalWidth)
        
        switch key {
        case "Space":
            return regularKeyWidth * 4
        case "?123", "ꓐꓑꓒ", "=\\<":
            return regularKeyWidth * 1.5
        case "Shift", "Unshift":
            return regularKeyWidth * 1.5
        case "Backspace":
            return regularKeyWidth * 1.5
        case "Return":
            return regularKeyWidth * 1.5
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
        let minHeight: CGFloat = DeviceHelper.isIPad() ? isLandscape ? 45 : 55 : isLandscape ? 32 : 40
        let maxHeight: CGFloat = DeviceHelper.isIPad() ? isLandscape ? 60 : 65 : isLandscape ? 38 : 42
        
        return max(min(baseHeight, maxHeight), minHeight)
    }

    static func getKeyAreaWidth(totalWidth: CGFloat) -> CGFloat {
        return totalWidth / CGFloat(maxKeysInRow)
    }

    static func getKeyAreaHeight(totalHeight: CGFloat) -> CGFloat {
        let isLandscape = DeviceHelper.isLandscape()
        return totalHeight / CGFloat(
            isLandscape ?
            4.5 : 4.6)
    }
}
