//
//  KeyboardConstants.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

enum KeyboardConstants {
    // Layout
    static let rowSpacing: CGFloat = 10
    static let keySpacing: CGFloat = 8
    static let verticalPadding: CGFloat = 8
    static let rowVerticalPadding: CGFloat = 10
    static let maxKeysPerRow = 10
    static let numberOfRows = 5
    static let maxKeyHeight: CGFloat = 45
    static let minKeyHeight: CGFloat = 40
    
    // Radius
    static let keyRadius: CGFloat = 6
    static let popoverRadius: CGFloat = 8
    
    // Colors
    static let darkSpecialKeyColor = Color(UIColor.systemGray4)
    static let darkRegularKeyColor = Color(UIColor.systemGray2)
    
    static let lightSpecialKeyColor = Color(UIColor(red: 171/255, green: 177/255, blue: 186/255, alpha: 0.5)) // #abb1ba
    static let lightRegularKeyColor = Color(UIColor.systemBackground)
    
    
    // Device specific heights
    static func getKeyboardHeight(isLandscape: Bool, isIPad: Bool) -> CGFloat {
        if isIPad {
            return isLandscape ? 250 : 340
        } else {
            return isLandscape ? 180 : 250
        }
    }
}
