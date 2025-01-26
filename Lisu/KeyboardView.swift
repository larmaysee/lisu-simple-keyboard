//
//  KeyboardView.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

struct KeyboardView: View {
    @StateObject private var keyboardState = KeyboardState.shared
    @ObservedObject var orientationManager: OrientationManager
    @State private var isLandscape: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let layout = keyboardState.getCurrentLayout()
            let keyboardWidth = geometry.size.width
            let keyboardHeight = geometry.size.height
            if keyboardWidth > 0 && keyboardHeight > 0 {
                VStack(spacing: 0) {                    
                    if keyboardWidth > 0 && keyboardHeight > 0 {
                        ZStack {
                            KeyboardContentView(keyboardWidth: keyboardWidth, keyboardHeight: keyboardHeight,layout: layout, keyboardState: keyboardState)
                            // Popover
                            if let showingKey = keyboardState.showingPopover {
                                if !isSpecialKey(showingKey) {
                                    GeometryReader { geometry in
                                        let currentRow = layout.rows.first(where: { $0.contains(showingKey) }) ?? []
                                        let rowIndex = layout.rows.firstIndex(where: { $0.contains(showingKey) }) ?? 0
                                        let buttonFrame = getKeyRect(for: showingKey, in: currentRow, at: rowIndex, in: geometry)
                                        KeyPopoverView(key: showingKey, width: buttonFrame.width)
                                            .position(x: buttonFrame.midX, y: max(buttonFrame.minY, 0))
                                            .transition(.opacity)
                                    }
                                }
                            }
                        } 
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(KeyboardConstants.keyboardBackgroundColor)
                        .onChange(of: isLandscape) { oldValue, newValue in
                            if oldValue != newValue {
                                updateOrientation(UIDevice.current.orientation) 
                            }
                            print("orientation changed to \(isLandscape ? "landscape" : "portrait")")
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .preferredColorScheme(ThemeSettings.shared.getCurrentColorScheme())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(KeyboardConstants.keyboardBackgroundColor)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            updateOrientation(UIDevice.current.orientation)
        }
    }
    
    private func isSpecialKey(_ key: String) -> Bool {
        return ["Shift", "Unshift", "?123", "ꓐꓑꓒ", "=\\<", "Space", "Backspace", "Return", "Keyboardchange"].contains(key)
    }
    
    private func getKeyRect(for key: String, in row: [String], at rowIndex: Int, in geometry: GeometryProxy) -> CGRect {
        let keyboardWidth = geometry.size.width
        let keyboardHeight = geometry.size.height
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        
        // Calculate Y position based on row index
        for i in 0..<keyboardState.getCurrentLayout().rows.count {
            if i < rowIndex {
                currentY += KeyboardLayoutHelper.getKeyHeight(totalHeight: keyboardHeight) + KeyboardConstants.keySpacing
            }
        }
        
        currentX = KeyboardConstants.keySpacing
        
        for (_, buttonKey) in row.enumerated() {
            let buttonWidth = KeyboardLayoutHelper.getKeyWidth(for: buttonKey, totalWidth: keyboardWidth, rowKeys: row, rowIndex: rowIndex)
            
            if buttonKey == key {
                return CGRect(x: currentX, y: currentY, width: buttonWidth, height: KeyboardLayoutHelper.getKeyHeight(totalHeight: geometry.size.height))
            }
            
            currentX += buttonWidth + KeyboardConstants.keySpacing
        }
        
        return .zero
    }

    func updateOrientation(_ orientation: UIDeviceOrientation) {
        isLandscape = orientation.isLandscape
    }
}

struct KeyboardContentView: View {
    let keyboardWidth: CGFloat
    let keyboardHeight: CGFloat
    let layout: KeyboardLayout
    @ObservedObject var keyboardState: KeyboardState

    var body: some View {
        VStack(spacing: KeyboardConstants.rowSpacing) {
            Spacer(minLength: 0)
            ForEach(layout.rows.indices, id: \.self) { rowIndex in
                HStack {
                    let rowWidth = calculateRowWidth(row: layout.rows[rowIndex])
                    Spacer(minLength: (keyboardWidth - rowWidth) / 2)
                    ForEach(layout.rows[rowIndex], id: \.self) { key in
                        let keyWidth = KeyboardLayoutHelper.getKeyWidth(for: key, totalWidth: keyboardWidth, rowKeys: layout.rows[rowIndex], rowIndex: rowIndex);
                        if rowIndex == 2 && willAddPrefixSpace(key: key) {
                            Spacer().frame(width: (keyWidth * 0.25) - KeyboardConstants.keySpacing)
                        }

                        KeyButton(
                            key: key,
                            width: keyWidth,
                            height: KeyboardLayoutHelper.getKeyHeight(totalHeight: keyboardHeight)
                        )
                        if rowIndex == 2 && willAddSuffixSpace(key: key) {
                            Spacer().frame(width: (keyWidth * 0.25) - KeyboardConstants.keySpacing)
                        }

                        if key != layout.rows[rowIndex].last {
                            Spacer().frame(width: KeyboardConstants.keySpacing)
                        }
                    }
                    Spacer(minLength: (keyboardWidth - rowWidth) / 2)
                }
            }
        }
        .padding(.vertical, KeyboardConstants.verticalPadding * (DeviceHelper.isLandscape() ? 0.3 : 0.5))
    }
    
    private func calculateRowWidth(row: [String]) -> CGFloat {
        let rowIndex = layout.rows.firstIndex(of: row) ?? 0
        let keysWidth = row.reduce(0) { result, key in
            let keyWidth = KeyboardLayoutHelper.getKeyWidth(for: key, totalWidth: keyboardWidth, rowKeys: row, rowIndex: rowIndex)
            
            // Add extra spacing for special keys in row 2
            var extraSpace: CGFloat = 0
            if rowIndex == 2 {
                if willAddPrefixSpace(key: key) {
                    extraSpace += (keyWidth * 0.25) - KeyboardConstants.keySpacing
                }
                if willAddSuffixSpace(key: key) {
                    extraSpace += (keyWidth * 0.25) - KeyboardConstants.keySpacing
                }
            }
            
            return result + keyWidth + extraSpace
        }
        let spacingWidth = CGFloat(row.count - 1) * KeyboardConstants.keySpacing
        return keysWidth + spacingWidth
    }

    private func willAddPrefixSpace(key: String) -> Bool {
        return ["Backspace"].contains(key)
    }

    private func willAddSuffixSpace(key: String) -> Bool {
        return["Shift", "Unshift", "?123","=\\<"].contains(key)
    }
}

struct KeyButton: View {
    let key: String
    let width: CGFloat
    let height: CGFloat
    @StateObject private var keyboardState = KeyboardState.shared
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: handleKeyPress) {
            ZStack {
                backgroundColor
                    .clipShape(RoundedCorner(
                        radius: KeyboardConstants.keyRadius,
                        corners: isPressed && !isSpecialKey ? [.bottomLeft, .bottomRight] : .allCorners
                    ))
                    .shadow(color: Color.black.opacity(0.35), radius: 0.5, x: 0, y: 1)
                
                keyContent
            }
        }
        .frame(width: width, height: height)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed && !isSpecialKey {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                            isPressed = true
                            keyboardState.setShowingPopover(for: key)
                        }
                    }
                }
                .onEnded { _ in
                    if isPressed {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                            isPressed = false
                            keyboardState.setShowingPopover(for: nil)
                        }
                    }
                }
        )
    }
    
    private func handleKeyPress() {
        switch key {
        case "Shift", "Unshift":
            withAnimation(.spring(response: 0.2)) {
                keyboardState.toggleShift()
            }
        case "?123":
            withAnimation(.spring(response: 0.2)) {
                keyboardState.switchToNumbers()
            }
        case "ꓐꓑꓒ":
            withAnimation(.spring(response: 0.2)) {
                keyboardState.switchToLetters()
            }
        case "=\\<":
            withAnimation(.spring(response: 0.2)) {
                keyboardState.switchToSymbols()
            }
        case "Space":
            NotificationCenter.default.post(name: NSNotification.Name("addKey"), object: " ")
        case "Backspace":
            NotificationCenter.default.post(name: NSNotification.Name("deleteKey"), object: nil)
        case "Return":
            NotificationCenter.default.post(name: NSNotification.Name("return"), object: nil)
        case "KeyboardChange":
            NotificationCenter.default.post(name: KeyboardNotification.keyboardChange, object: nil)
        default:
            let keyToSend = keyboardState.isShifted ? key.uppercased() : key
            NotificationCenter.default.post(name: NSNotification.Name("addKey"), object: keyToSend)
            // Reset shift state after key press
            if keyboardState.isShifted {
                withAnimation(.spring(response: 0.2)) {
                    keyboardState.toggleShift()
                }
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
            return KeyboardConstants.specialKeyColor
        }
        return KeyboardConstants.regularKeyColor
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
                            .font(FontHelper.customFont(size: 18))
                            .fontWeight(.medium)
                            .transition(.opacity.combined(with: .scale))
                    } else {
                        Text("space")
                            .font(FontHelper.customFont(size: 18))
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
                    .font(FontHelper.customFont(size: 16))
                    .fontWeight(.medium)
            default:
                Text(key)
                    .font(FontHelper.customFont(size: 22))
                    .fontWeight(.medium)
            }
        }
        .foregroundColor(.black)
    }
}

struct KeyPopoverView: View {
    let key: String
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Text(key)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.black)
                .frame(width: max(width * 1.4, 45), height: 45)
                .background(
                    RoundedRectangle(cornerRadius: KeyboardConstants.popoverRadius)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                )
            
            Rectangle()
                .fill(Color.white)
                .frame(width: width * 0.6, height: 8)
                .offset(y: -4)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension KeyboardView {
    var intrinsicHeight: CGFloat {
        return UIDevice.current.orientation.isLandscape ? DeviceHelper.getKeyboardHeight() * 0.8 : DeviceHelper.getKeyboardHeight()
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(orientationManager: OrientationManager())
            .frame(height:
                UIDevice.current.orientation.isLandscape ?
                DeviceHelper.getKeyboardHeight() * 0.8 :
                DeviceHelper.getKeyboardHeight()
            )
            .previewLayout(.sizeThatFits)
    }
}
