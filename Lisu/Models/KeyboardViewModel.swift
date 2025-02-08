//
//  KeyboardViewModel.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 28/01/2025.
//

import SwiftUI
import Combine

protocol KeyboardViewModelDelegate: AnyObject {
    func insertText(_ text: String)
    func deleteBackward()
    func handleReturn()
    func handleTab()
    func handleUndo()
    func handleRedo()
    func handleKeyboardChange()
}

class KeyboardViewModel: ObservableObject {
    enum KeyAction {
        case character(String)
        case backspace
        case shift
        case unshift
        case numbers
        case symbols
        case `return`
        case space
        case tab
        case undo
        case redo
        case keyboardChange
        case layoutChange(String)
        case unknown
    }
    
    @Published var keyboardState: KeyboardLayoutConfig.LayoutType = .default
    @Published var pressedKey: String?
    @Published var isShifted: Bool = false
    @Published var showNumbers: Bool = false
    @Published var showSymbols: Bool = false
    @Published var capsLock: Bool = false

    weak var delegate: KeyboardViewModelDelegate?

    @Published var undoStack: [String] = []  // Stores previous words
    @Published var redoStack: [String] = []  // Stores undone words

    var textDocumentProxy: UITextDocumentProxy?
    
    // Handle both iPhone and iPad key actions
    func handleKeyPress(_ key: String, isDoubleTap: Bool = false) {
        let action = parseKeyAction(key)
        
        switch action {
        case .character(let char):
            delegate?.insertText(char)
            resetShiftState()
            
        case .backspace:
            delegate?.deleteBackward()
            resetShiftState()
            
        case .shift:
            if isDoubleTap {
                capsLock.toggle()
            } else {
               capsLock = false
            }
            
            isShifted = true
            keyboardState = .shifted
            
        case .unshift:
            capsLock = false
            isShifted = false
            keyboardState = .default
            
            
        case .numbers:
            showNumbers = true
            showSymbols = false
            keyboardState = .numbers
            
        case .symbols:
            showSymbols = true
            showNumbers = false
            keyboardState = .symbols
        case .return:
            delegate?.handleReturn()
            resetShiftState()
            
        case .space:
            delegate?.insertText(" ")
            saveWordState()
            resetShiftState()
            
        case .tab:
            delegate?.handleTab()
            resetShiftState()
            
        case .undo:
            undo()
            resetShiftState()
            
        case .redo:
            redo()
            resetShiftState()
            
        case .keyboardChange:
            delegate?.handleKeyboardChange()
            resetShiftState()
            
        case .layoutChange(let layout):
            handleLayoutChange(layout)
            
        case .unknown:
            break
        }
        
        resetPressedKey()
    }
    
    func onPressed(_ key: String) {
        print("onPressed: \(key)")
        pressedKey = key
    }

    // Capture the latest word entered
    func saveWordState() {
        guard let text = textDocumentProxy?.documentContextBeforeInput, !text.isEmpty else { return }

        let words = text.split(separator: " ").map { String($0) }
        if let lastWord = words.last {
            undoStack.append(lastWord)
        }

        redoStack.removeAll() // Reset redo stack on new input
    }

    // Undo last word
    func undo() {
        guard !undoStack.isEmpty else { return }
        
        if let text = textDocumentProxy?.documentContextBeforeInput {
            redoStack.append(text) // Save current state for redo
        }

        let removedWord = undoStack.popLast() ?? ""
        removeLastWord(removedWord)
    }

    // Redo last undone word
    func redo() {
        guard !redoStack.isEmpty else { return }

        if let text = textDocumentProxy?.documentContextBeforeInput {
            undoStack.append(text) // Save current state for undo
        }

        let restoredWord = redoStack.popLast() ?? ""
        textDocumentProxy?.insertText(" " + restoredWord)
    }

    // Remove the last word from the text input
    private func removeLastWord(_ word: String) {
        guard let text = textDocumentProxy?.documentContextBeforeInput else { return }
        let trimmedText = text.dropLast(word.count)
        replaceText(with: String(trimmedText))
    }

    // Replace text in the textDocumentProxy
    private func replaceText(with newText: String) {
        let length = textDocumentProxy?.documentContextBeforeInput?.count ?? 0
        textDocumentProxy?.adjustTextPosition(byCharacterOffset: -length)
        textDocumentProxy?.insertText(newText)
    }


    private func resetShiftState() {
        if isShifted && !capsLock{
            isShifted = false
            keyboardState = .default
        }

        if showNumbers {
            showNumbers = false
            keyboardState = .default
        }

        if showSymbols {
            showSymbols = false
            keyboardState = .default
        }
    }
    
    private func parseKeyAction(_ key: String) -> KeyAction {
        switch key {
        case SpecialKeys.shift, SpecialKeys.shift2: return .shift
        case SpecialKeys.unshift, SpecialKeys.unshift2: return .unshift
        case SpecialKeys.backspace: return .backspace
        case SpecialKeys.return: return .return
        case SpecialKeys.space: return .space
        case SpecialKeys.tab: return .tab
        case SpecialKeys.undo: return .undo
        case SpecialKeys.redo: return .redo
        case SpecialKeys.keyboardChange: return .keyboardChange
        case SpecialKeys.numbers, SpecialKeys.numbers2: return .numbers
        case SpecialKeys.symbols, SpecialKeys.symbols2: return .symbols
        case SpecialKeys.bpd, SpecialKeys.bpd2: return .layoutChange("default")
        case SpecialKeys.english: return .keyboardChange
        default:
            return .character(key)
        }
    }
    
    private func handleLayoutChange(_ layout: String) {
        switch layout {
        case "default":
            showNumbers = false
            showSymbols = false
            keyboardState = .default
        case "numbers":
            keyboardState = .numbers
        case "symbols":
            keyboardState = .symbols
        default:
            break
        }
    }
    
    func resetPressedKey() {
        pressedKey = nil
    }
    
    private func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        HapticEngine.triggerFeedback(style)
    }
}
