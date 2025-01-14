import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var currentTheme: ThemeMode {
        didSet {
            ThemeSettings.shared.selectedTheme = currentTheme
        }
    }
    
    init() {
        self.currentTheme = ThemeSettings.shared.selectedTheme
    }
    
    var preferredColorScheme: ColorScheme? {
        ThemeSettings.shared.getCurrentColorScheme()
    }
}
