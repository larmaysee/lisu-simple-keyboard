import SwiftUI

class KeyboardViewModel: ObservableObject {
    weak var delegate: KeyboardViewDelegate?

    func tapKey(_ key: String) {
        delegate?.didTapKey(key)
    }

    func tapBackspace() {
        delegate?.didTapBackspace()
    }
    
    func tapReturn() {
        delegate?.didTapReturn()
    }
    
    func tapKeyboardChange() {
        delegate?.ditTapKeyboardChange()
    }
}
