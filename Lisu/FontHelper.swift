import SwiftUI
import CoreText
import UIKit

enum FontHelper {
    static func registerFonts() {
        // Use the correct bundle for the keyboard extension
        guard let bundle = Bundle(identifier: "co.codibyte.Lisu-Keyboard.Lisu") else {
            print("Could not find extension bundle")
            return
        }

        // First, try to register a specific font
        if let fontURL = bundle.url(forResource: "Fonts/LisuBosa-Regular", withExtension: "ttf") {
            registerFont(at: fontURL)
        } else {
            print("Could not find LisuBosa-Regular.ttf in directory")
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
        // Check if the font is available
        if UIFont(name: "LisuBosa-Regular", size: size) != nil {
            return Font.custom("LisuBosa-Regular", size: size)
        } else {
            print("LisuBosa-Regular font not available, falling back to system font")
            return Font.system(size: size)
        }
    }
}
