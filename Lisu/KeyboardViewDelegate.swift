//
//  KeyboardViewDelegate.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 27/01/2025.
//

import Foundation

protocol KeyboardViewDelegate: AnyObject {
    func didTapKey(_ key: String)
    func didTapBackspace()
    func didTapReturn()
    func ditTapKeyboardChange()
}
