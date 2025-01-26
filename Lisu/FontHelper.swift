import SwiftUI
import UIKit

enum FontHelper {
    static func registerFonts() {
        // First try to register from bundle
        if let fontURL = Bundle.main.url(forResource: "LisuBosa-Regular", withExtension: "ttf", subdirectory: "Fonts") {
            registerFont(at: fontURL)
        } else {
            print("Could not find LisuBosa-Regular.ttf in bundle")
            
            // Try to register from Fonts directory as fallback
            guard let fontsURL = Bundle.main.url(forResource: "Fonts", withExtension: nil) else {
                print("Could not find Fonts directory")
                return
            }
            
            do {
                let fontFiles = try FileManager.default.contentsOfDirectory(at: fontsURL, includingPropertiesForKeys: nil)
                for fontFile in fontFiles {
                    registerFont(at: fontFile)
                }
            } catch {
                print("Error loading fonts directory: \(error)")
            }
        }
    }
    
    private static func registerFont(at url: URL) {
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) else {
            if let error = error?.takeRetainedValue() {
                print("Error registering font: \(error)")
            } else {
                print("Unknown error registering font")
            }
            return
        }
        print("Successfully registered font: \(url.lastPathComponent)")
    }
    
    static func customFont(size: CGFloat) -> Font {
        // Check if font is available
        if UIFont(name: "LisuBosa-Regular", size: size) != nil {
            return Font.custom("LisuBosa-Regular", size: size)
        } else {
            print("LisuBosa-Regular font not available, falling back to system font")
            return Font.system(size: size)
        }
    }
}
