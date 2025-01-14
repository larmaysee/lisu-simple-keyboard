//
//  DeviceHelper.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

enum DeviceHelper {
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static func isLandscape() -> Bool {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    static func getKeyboardHeight() -> CGFloat {
        return KeyboardConstants.getKeyboardHeight(
            isLandscape: isLandscape(),
            isIPad: isIPad()
        )
    }
}
