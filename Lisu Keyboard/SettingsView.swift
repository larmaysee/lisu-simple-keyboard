//
//  SettingsView.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

enum ThemeMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

class ThemeSettings {
    static let shared = ThemeSettings()
    private init() {}
    
    @AppStorage("selectedTheme") var selectedTheme: ThemeMode = .system
    
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

struct SettingsView: View {
    @State private var selectedTheme: ThemeMode = ThemeSettings.shared.selectedTheme
    @AppStorage("keyClickSound", store: UserDefaults(suiteName: "group.co.codibyte.Lisu-Keyboard")) private var keyClickSound: Bool = true
    
    var body: some View {
        Form {
            Section {
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(ThemeMode.allCases, id: \.self) { theme in
                        Text(theme.rawValue).tag(theme)
                    }
                }
                .onChange(of: selectedTheme) { oldValue, newValue in
                    ThemeSettings.shared.selectedTheme = newValue
                }
            } header: {
                Text("Appearance")
                    .textCase(nil)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Section {
                Toggle("Key Click Sound", isOn: $keyClickSound)
            } header: {
                Text("Sound")
                    .textCase(nil)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Section {
                Link("View Source Code", destination: URL(string: "https://github.com/yourusername/lisu_simple_keyboard")!)
                Text("Version 1.0.0")
            } header: {
                Text("About")
                    .textCase(nil)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(ThemeSettings.shared.getCurrentColorScheme())
    }
}
