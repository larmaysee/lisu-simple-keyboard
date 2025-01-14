//
//  KeyboardState.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

class KeyboardState: ObservableObject {
    @Published var isShifted: Bool = false
    @Published var isNumberPad: Bool = false
    @Published var isSymbolPad: Bool = false
    @Published var showingPopover: String? = nil
    @Published var showKeyboardName: Bool = true
    
    static let shared = KeyboardState()
    
    private init() {
        // Automatically hide keyboard name after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.linear(duration: 0.5)) {
                self.showKeyboardName = false
            }
        }
    }
    
    func getCurrentLayout() -> KeyboardLayout {
        return KeyboardLayout.getCurrentLayout(
            isShifted: isShifted,
            isNumberPad: isNumberPad,
            isSymbolPad: isSymbolPad
        )
    }
    
    func toggleShift() {
        isShifted.toggle()
    }
    
    func switchToNumbers() {
        isNumberPad = true
        isSymbolPad = false
        isShifted = false
    }
    
    func switchToLetters() {
        isNumberPad = false
        isSymbolPad = false
        isShifted = false
    }
    
    func switchToSymbols() {
        isSymbolPad = true
        isNumberPad = false
        isShifted = false
    }
    
    func setShowKeyboardName(_ show: Bool) {
        showKeyboardName = show
    }
    
    func reset() {
        isShifted = false
        isNumberPad = false
        isSymbolPad = false
        showingPopover = nil
        showKeyboardName = true
    }
    
    func setShowingPopover(for key: String?) {
        showingPopover = key
    }
}
