import UIKit
import AudioToolbox

class SoundManager {
    static let shared = SoundManager()
    
    private init() {}
    
    func playKeyClick() {
        if UserDefaults(suiteName: "group.co.codibyte.Lisu-Keyboard")?.bool(forKey: "keyClickSound") ?? true {
            DispatchQueue.main.async {
                AudioServicesPlaySystemSound(1104) // iOS keyboard click sound
            }
        }
    }
}
