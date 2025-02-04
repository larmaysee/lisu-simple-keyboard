//
//  KeyboardConstants.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

enum KeyboardConstants {
    
    static let keyContentPadding: CGFloat = 5
    static let heightRatioPortrait: CGFloat = 0.4
    static let heightRatioLandscape: CGFloat = 0.35
    
    // Mark: Iphone
    // keyboard height
    static let iOSMaxHeight: CGFloat = 300
    static let iOSMinHeight: CGFloat = 230
    
    static let iOSLandscapeMaxHeight: CGFloat = 200
    static let iOSLandscapeMinHeight: CGFloat = 180
    
    // key padding
    static let iOSVerticalPadding : CGFloat = 5
    static let iOSHorizontalPadding : CGFloat = 2
    
    // max row
    static let iOSMaxRow = 4
    
    // key height
    static let iOSKeyButtonHeight: CGFloat = iOSMinHeight / CGFloat(iOSMaxRow)
    static let iOSKeyContentHeight: CGFloat = iOSKeyButtonHeight - (iOSVerticalPadding * 2)
    
    static let iOSMaxKeyHeightLandscape: CGFloat = 35
    
    
    // Mark: - iPad
    // keyboard height
    static let iPadMaxHeight: CGFloat = 455
    static let iPadMinHeight: CGFloat = 350

    static let iPadLandscapeMaxHeight: CGFloat = 380
    static let iPadLandscapeMinHeight: CGFloat = 280
    
    // max row
    static let iPadMaxRow = 5
    
    // key padding
    static let iPadVerticalPadding : CGFloat = 5
    static let iPadHorizontalPadding : CGFloat = 5
    
    // key height
    static let iPadKeyButtonHeight: CGFloat = iPadMinHeight / CGFloat(iPadMaxRow)
    static let iPadKeyContentHeight: CGFloat = iPadKeyButtonHeight - (iPadVerticalPadding * 2)
    
    // Radius
    static let keyRadius: CGFloat = 10
    static let popoverRadius: CGFloat = 8
    
    // colors
    static let keyPressedColor = Color(UIColor.systemGray)
    
    // dark
    static let darkSpecialKeyColor = Color(UIColor.systemGray4)
    static let darkRegularKeyColor = Color(UIColor.systemGray2)
    
    // light
    static let lightSpecialKeyColor = Color(UIColor(red: 171/255, green: 177/255, blue: 186/255, alpha: 0.5))
    static let lightRegularKeyColor = Color(UIColor.systemBackground)
    
        
    static let darkKeyboardBackground = Color(UIColor.systemGray6)
    static let lightKeyboardBackground = Color(UIColor.systemBackground)
    
    static let keyAnimation = Animation.interactiveSpring(
        response: 0.1,
        dampingFraction: 0.8,
        blendDuration: 0.2
    )
}
