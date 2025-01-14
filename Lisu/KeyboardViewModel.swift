import SwiftUI

class KeyboardViewModel: ObservableObject {
    @Published var currentTheme: ThemeMode
    
    init() {
        self.currentTheme = ThemeSettings.shared.selectedTheme
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ThemeChanged"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let newTheme = notification.object as? ThemeMode {
                self?.currentTheme = newTheme
            }
        }
    }
}
