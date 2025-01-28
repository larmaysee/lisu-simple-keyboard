//
//  KeyButton.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 27/01/2025.
//
import SwiftUI
import UIKit

struct KeyButton: View {
    @ObservedObject var viewModel: KeyboardViewModel
    @StateObject private var keyboardState = KeyboardState.shared
    @State private var isPressed: Bool = false
    @Environment(\.colorScheme) var colorScheme
    let key: String
    let width: CGFloat
    let height: CGFloat
    let areaWidth: CGFloat
    let areaHeight: CGFloat
    let rowIndex: Int
    let rowKeys: [String]
    let layout: KeyboardLayout
    
    var body: some View {
        Button(action: action) {
            ZStack {               
                keyContent
                    .frame(width: width, height: height)
                    .background(backgroundColor)
                    .shadow(color: Color.black.opacity(0.2), radius: 0.5, x: 0, y: 1.5)
                    .cornerRadius(KeyboardConstants.keyRadius)
                    .offset(x: getContentOffset())
            }
            .frame(width: areaWidth, height: areaHeight)
        }
        .buttonStyle(KeyButtonStyle())
        .background(
            Color(.red).opacity(1)
        )
        .blur(radius: 0.1)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed && !isSpecialKey {
                        isPressed = true    
                        keyboardState.setShowingPopover(for: key)
                    }
                }
                .onEnded { _ in
                    if isPressed {
                        isPressed = false
                        keyboardState.setShowingPopover(for: nil)
                    }
                }
        )
    }
    
    private func action() {
        switch key {
        case "Shift", "Unshift":
            keyboardState.toggleShift()
        case "?123":
            keyboardState.switchToNumbers()
        case "ꓐꓑꓒ":
            keyboardState.switchToLetters()
        case "=\\<":
            keyboardState.switchToSymbols()
        case "Space":
            viewModel.tapKey(" ")
        case "Backspace":
            viewModel.tapBackspace()
        case "Return":
            viewModel.tapReturn()
        case "KeyboardChange":
            viewModel.tapKeyboardChange()
        default:
            let keyToSend = keyboardState.isShifted ? key.uppercased() : key
            viewModel.tapKey(keyToSend)
            if keyboardState.isShifted {
                keyboardState.toggleShift()
            }
        }
    }
    
    private var isSpecialKey: Bool {
        ["Shift", "Unshift", "?123", "ꓐꓑꓒ", "=\\<", "Space", "Backspace", "Return", "KeyboardChange"].contains(key)
    }
    
    private var isColorSpecialKey: Bool {
        ["Unshift", "?123", "ꓐꓑꓒ", "=\\<", "Backspace", "Return", "KeyboardChange"].contains(key)
    }
    
    private var backgroundColor: Color {
        if isColorSpecialKey {
            return colorScheme == .dark ? KeyboardConstants.darkSpecialKeyColor : KeyboardConstants.lightSpecialKeyColor
        }
        return colorScheme == .dark ? KeyboardConstants.darkRegularKeyColor : KeyboardConstants.lightRegularKeyColor
    }
    
    private var keyContent: some View {
        Group {
            switch key {
            case "Shift", "Unshift":
                Image(systemName: "shift.fill")
                    .font(.system(size: 20))
            case "Backspace":
                Image(systemName: "delete.left.fill")
                    .font(.system(size: 20))
            case "Return":
                Image(systemName: "return")
                    .font(.system(size: 20))
            case "Space":
                ZStack {
                    if keyboardState.showKeyboardName {
                        Text("Lisu")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .transition(.opacity.combined(with: .scale))
                    } else {
                        Text("space")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .animation(.linear(duration: 0.5), value: keyboardState.showKeyboardName)
            case "KeyboardChange":
                Image(systemName: "globe")
                    .font(.system(size: 20))
            case "?123", "ꓐꓑꓒ", "=\\<":
                Text(key)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            default:
                Text(key)
                    .font(
                        !KeyboardState.shared.isSymbolPad && !KeyboardState.shared.isNumberPad ?
                            FontHelper.customFont(size: 23) :
                            Font.system(size: 18)
                    )
            }
        }
        .foregroundColor(Color(UIColor.label))
    }
    
    private func getContentOffset() -> CGFloat {
        if rowIndex == 1 && !KeyboardState.shared.isSymbolPad && !KeyboardState.shared.isNumberPad {
            if rowKeys.first == key {
                return (KeyboardConstants.keySpacing * 2) / 2
            } else if rowKeys.last == key { 
                return -(KeyboardConstants.keySpacing * 2) / 2
            }
        }
        return 0
    }
}

struct KeyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
