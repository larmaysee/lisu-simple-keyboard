//
//  ThemeSettings.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import Foundation
import SwiftUI

enum ThemeMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

class ThemeSettings {
    static let shared = ThemeSettings()
    
    // Use App Groups to share settings between main app and keyboard extension
    private let defaults = UserDefaults(suiteName: "group.co.codibyte.Lisu-Keyboard")!
    private let themeKey = "selectedTheme"
    
    private init() {}
    
    var selectedTheme: ThemeMode {
        get {
            if let savedTheme = defaults.string(forKey: themeKey),
               let theme = ThemeMode(rawValue: savedTheme) {
                return theme
            }
            return .system
        }
        set {
            defaults.set(newValue.rawValue, forKey: themeKey)
        }
    }
    
    func getCurrentColorScheme() -> ColorScheme? {
        switch selectedTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
