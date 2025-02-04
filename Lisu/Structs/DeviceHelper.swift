//
//  DeviceHelper.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

struct DeviceHelper {
    private init() {}
    
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isLandscape: Bool {
        UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    static var keyboardHeight: CGFloat {
        KeyboardHeightEnvironment.currentHeight
    }
}
