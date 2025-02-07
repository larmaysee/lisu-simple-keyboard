//
//  KeyboardLayout.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 28/01/2025.
//

struct KeyboardLayout {
    let rows: [[String]]
}

struct KeyboardLayoutConfig {
    // Common keyboard elements
    private static let backspace = SpecialKeys.backspace
    private static let space = SpecialKeys.space
    private static let `return` = SpecialKeys.return
    private static let shift = SpecialKeys.shift
    private static let shift2 = SpecialKeys.shift2
    private static let unshift = SpecialKeys.unshift
    private static let unshift2 = SpecialKeys.unshift2
    private static let keyboardChange = SpecialKeys.keyboardChange
    private static let symbols = SpecialKeys.symbols
    private static let symbols2 = SpecialKeys.symbols2
    private static let numbers = SpecialKeys.numbers
    private static let numbers2 = SpecialKeys.numbers2
    private static let bpd = SpecialKeys.bpd
    private static let bpd2 = SpecialKeys.bpd2
    private static let undo = SpecialKeys.undo
    private static let redo = SpecialKeys.redo
    private static let tab = SpecialKeys.tab
    private static let english = SpecialKeys.english
    
    // Layout types
    enum LayoutType {
        case `default`
        case shifted
        case numbers
        case symbols
    }
    
    // Device type handling
    enum DeviceType {
        case iphone
        case ipad
        
        static var current: DeviceType {
            return DeviceHelper.isIPad ? .ipad : .iphone
        }
    }
    
    static func getLayout(for type: LayoutType, device: DeviceType = .current) -> KeyboardLayout {
        switch (device, type) {
        case (.ipad, .default):
            return ipadDefaultLayout
        case (.ipad, .shifted):
            return ipadShiftedLayout
        case (.ipad, .numbers):
            return ipadNumberLayout
        case (.ipad, .symbols):
            return ipadSymbolLayout
        case (.iphone, .default):
            return defaultLayout
        case (.iphone, .shifted):
            return shiftedLayout
        case (.iphone, .numbers):
            return numberLayout
        case (.iphone, .symbols):
            return symbolLayout
        }
    }
    
    // MARK: - iPhone Layouts
    private static let defaultLayout = KeyboardLayout(rows: [
        ["ʼ", "ꓪ","ꓰ","ꓣ","ꓔ","ꓬ","ꓴ","ꓲ","ꓳ","ꓑ"],
        ["ꓮ","ꓢ","ꓓ","ꓝ","ꓖ","ꓧ","ꓙ","ꓗ","ꓡ"],
        [shift, "ꓜ","ꓫ","ꓚ","ꓦ","ꓐ","ꓠ","ꓟ", backspace],
        [numbers,"꓾", keyboardChange, space, "꓿", `return`]
    ])
    
    private static let shiftedLayout = KeyboardLayout(rows: [
        ["ʼ", "ꓼ","ꓱ","ꓤ","ꓕ","ꓻ","ꓵ","ꓹꓼ","ˍ","ꓒ"],
        ["ꓯ","ꓽ","ꓷ","ꓞ","ꓨ","ꓺ","ꓩ","ꓘ","ꓶ"],
        [unshift, "ꓹ","ꓸ","ꓛ","ꓥ","ꓭ","-","ꓸꓼ", backspace],
        [numbers,"꓾", keyboardChange, space, "꓿", `return`]
    ])
    
    private static let numberLayout = KeyboardLayout(rows: [
        ["1","2","3","4","5","6","7","8","9","0"],
        ["@","#","$","_","&","-","+","(",")","/"],
        [symbols,"*","\"","\'",":",";","!","?", backspace],
        [bpd,",", keyboardChange, space, ".", `return`]
    ])
    
    private static let symbolLayout = KeyboardLayout(rows: [
        ["~","`","|","•","√","π","÷","×","§","∆"],
        ["£","¢","€","¥","^","°","=","{","}","\\"],
        [numbers,"%","©","®","™","✓","[","]", backspace],
        [bpd,"<", keyboardChange, space, ">", `return`]
    ])
    
    // MARK: - iPad Layouts
    private static let ipadDefaultLayout = KeyboardLayout(rows: [
        ["`","1","2","3","4","5","6","7","8","9","0","-","=", backspace],
        [tab,"ʼ", "ꓪ","ꓰ","ꓣ","ꓔ","ꓬ","ꓴ","ꓲ","ꓳ","ꓑ","[","]", "\\"],
        [english,"ꓮ","ꓢ","ꓓ","ꓝ","ꓖ","ꓧ","ꓙ","ꓗ","ꓡ","ꓼ","\'", `return`],
        [shift, "ꓜ","ꓫ","ꓚ","ꓦ","ꓐ","ꓠ","ꓟ","ꓹ","ꓸ","/", shift2],
        [keyboardChange, numbers,"꓾", space, "꓿", numbers2, symbols2]
    ])
    
    private static let ipadShiftedLayout = KeyboardLayout(rows: [
        ["~","!","@","#","$","%","^","&","*","(",")","_","+", backspace],
        [tab,"ʼ", "ꓼ","ꓱ","ꓤ","ꓕ","ꓻ","ꓵ","ꓹꓼ","ˍ","ꓒ","{","}", "|"],
        [english,"ꓯ","•","ꓷ","ꓞ","ꓨ","ꓺ","ꓩ","ꓘ","ꓶ","ꓽ","\"", `return`],
        [unshift,"“","”","ꓛ","ꓥ","ꓭ","-","ꓸꓼ", "ꓹ","ꓸ","?", unshift2],
        [keyboardChange, numbers,"꓾", space, "꓿", numbers2, symbols2]
    ])
    
    private static let ipadNumberLayout = KeyboardLayout(rows: [
        ["`","1","2","3","4","5","6","7","8","9","0","<", ">", backspace],
        [tab,"[","]","{","}","#","%","^","*","+","=", "\\","|", "~"],
        [undo,"-","/",":",";","(",")","$","&","@","£","¥", `return`],
        [redo,"…",".",",","?","!","'","\"","_","€", "π"],
        [keyboardChange, bpd,symbols, space, ".", bpd2, symbols2]
    ])
    
    private static let ipadSymbolLayout = KeyboardLayout(rows: [
        ["±","≠","∞","≈","∅","∈","∏","∑","√","∇","ℵ","⊂","⊃", backspace],
        [tab,"∧","∨","∩","∪","∴","∵","⊢","⊨","≡","≤","≥","⊆","⊇"],
        [undo,"¬","⇒","⇔","∀","∃","∂","∫","∮","ℜ","ℑ","℘", `return`],
        [redo,"←","→","↑","↓","↔","↦","↵","⇄","⇤","⇥", "⌘"],
        [keyboardChange, bpd, numbers,  space, "⌥", numbers2, bpd2]
    ])
}
