//
//  TapModifier.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 29/01/2025.
//

import SwiftUI

// Custom View Modifier to handle double taps
struct TapModifier: ViewModifier {
    let singleTapAction: () -> Void
    let doubleTapAction: () -> Void
    let isShiftKey: Bool
    private let maxInterval: TimeInterval = 0.18
    
    @State private var tapCount = 0
    @State private var timer: Timer?

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                handleTapGesture()
            }
    }
    
    private func handleTapGesture() {
        if isShiftKey {
            tapCount += 1
            print("tap count \(tapCount)")
            
            if tapCount == 1 {
                timer = Timer.scheduledTimer(withTimeInterval: maxInterval, repeats: false) { _ in
                    if tapCount == 1 {
                        singleTapAction()
                    }
                    resetTapCount()
                }
            } else if tapCount == 2 {
                timer?.invalidate()
                doubleTapAction()
                resetTapCount()
            }
        } else {
            singleTapAction()
            resetTapCount();
        }
    }
    
    private func resetTapCount() {
        tapCount = 0
        timer = nil
    }
}
