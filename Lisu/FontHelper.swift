import SwiftUI
import UIKit

enum FontHelper {
    static func registerFonts() {
        // Register all fonts in the Fonts directory
        guard let fontsURL = Bundle.main.url(forResource: "Fonts", withExtension: nil) else {
            print("Could not find Fonts directory")
            return
        }
        
        do {
            let fontFiles = try FileManager.default.contentsOfDirectory(at: fontsURL, includingPropertiesForKeys: nil)
            for fontFile in fontFiles {
                var error: Unmanaged<CFError>?
                guard CTFontManagerRegisterFontsForURL(fontFile as CFURL, .process, &error) else {
                    print("Error registering font: \(error.debugDescription)")
                    continue
                }
            }
        } catch {
            print("Error loading fonts: \(error)")
        }
    }
    
    static func customFont(size: CGFloat) -> Font {
        // Use Lisu Bosa font, fallback to system font if not available
        Font.custom("LisuBosa-Regular", size: size)
    }
}
