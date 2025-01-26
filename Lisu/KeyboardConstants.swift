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
    static let keySpacing: CGFloat = 6
    static let verticalPadding: CGFloat = 6
    static let rowVerticalPadding: CGFloat = 8
    static let maxKeysPerRow = 10
    static let numberOfRows = 4
    static let maxKeyHeight: CGFloat = 45
    static let minKeyHeight: CGFloat = 38
    
    // Radius
    static let keyRadius: CGFloat = 5
    static let popoverRadius: CGFloat = 8
    
    // Colors
    static let specialKeyColor = Color(red: 171/255, green: 177/255, blue: 186/255, opacity: 0.8)
    static let regularKeyColor = Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.9)
    static let keyboardBackgroundColor = Color(red: 210/255, green: 212/255, blue: 217/255, opacity: 0.8)
    
    // Device specific heights
    static func getKeyboardHeight(isLandscape: Bool, isIPad: Bool) -> CGFloat {
        if isIPad {
            return isLandscape ? 250 : 340
        } else {
            return isLandscape ? 180 : 250
        }
    }
}
