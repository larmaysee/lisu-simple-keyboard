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
        VStack(spacing: 0) {
            let layout = keyboardState.getCurrentLayout()
            let keyboardWidth = UIScreen.main.bounds.width
            let keyboardHeight = UIScreen.main.bounds.height
            
            if keyboardWidth > 0 && keyboardHeight > 0 {
                ZStack {
                    KeyboardContentView(keyboardWidth: keyboardWidth, keyboardHeight: keyboardHeight,layout: layout, keyboardState: keyboardState)
                    // Popover
                    if let showingKey = keyboardState.showingPopover {
                        if !isSpecialKey(showingKey) {
                            GeometryReader { geometry in
                                if let buttonFrame = getButtonFrame(for: showingKey, in: geometry, layout: layout, keyboardWidth: keyboardWidth) {
                                    KeyPopoverView(key: showingKey, width: buttonFrame.width)
                                        .position(x: buttonFrame.midX, y: max(buttonFrame.minY, 0))
                                        .transition(.opacity)
                                        .zIndex(1)
                                }
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
    
    private func isSpecialKey(_ key: String) -> Bool {
        return ["shift", "unshift", "123", "Abc", "sym", "space", "backspace", "return", "keyboardchange"].contains(key)
    }
    
    private func getButtonFrame(for key: String, in geometry: GeometryProxy, layout: KeyboardLayout, keyboardWidth: CGFloat) -> CGRect? {
        var currentX: CGFloat = KeyboardConstants.keySpacing
        var currentY: CGFloat = KeyboardConstants.verticalPadding * (DeviceHelper.isLandscape() ? 0.3 : 0.5)
        
        for (_, row) in layout.rows.enumerated() {
            currentX = KeyboardConstants.keySpacing
            
            for (_, buttonKey) in row.enumerated() {
                let buttonWidth = KeyboardLayoutHelper.getKeyWidth(for: buttonKey, totalWidth: keyboardWidth, rowKeys: row)
                
                if buttonKey == key {
                    return CGRect(x: currentX, y: currentY, width: buttonWidth, height: KeyboardLayoutHelper.getKeyHeight(totalHeight: geometry.size.height))
                }
                
                currentX += buttonWidth + KeyboardConstants.keySpacing
            }
            
            currentY += KeyboardLayoutHelper.getKeyHeight(totalHeight: geometry.size.height) + KeyboardConstants.rowSpacing
        }
        
        return nil
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
                HStack(spacing: KeyboardConstants.keySpacing) {
                    ForEach(layout.rows[rowIndex], id: \.self) { key in
                        KeyButton(
                            key: key,
                            width: KeyboardLayoutHelper.getKeyWidth(for: key, totalWidth: keyboardWidth, rowKeys: layout.rows[rowIndex]),
                            height: KeyboardLayoutHelper.getKeyHeight(totalHeight: keyboardHeight)
                        )
                    }
                }
                .padding(.horizontal, KeyboardConstants.keySpacing)
            }
        }
        .padding(.vertical, KeyboardConstants.verticalPadding * (DeviceHelper.isLandscape() ? 0.3 : 0.5))
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
                        radius: 5,
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
        case "shift", "unshift":
            withAnimation(.spring(response: 0.2)) {
                keyboardState.toggleShift()
            }
        case "123":
            withAnimation(.spring(response: 0.2)) {
                keyboardState.switchToNumbers()
            }
        case "Abc":
            withAnimation(.spring(response: 0.2)) {
                keyboardState.switchToLetters()
            }
        case "sym":
            withAnimation(.spring(response: 0.2)) {
                keyboardState.switchToSymbols()
            }
        case "space":
            NotificationCenter.default.post(name: NSNotification.Name("addKey"), object: " ")
        case "backspace":
            NotificationCenter.default.post(name: NSNotification.Name("deleteKey"), object: nil)
        case "return":
            NotificationCenter.default.post(name: NSNotification.Name("return"), object: nil)
        case "keyboardchange":
            NotificationCenter.default.post(name: NSNotification.Name("keyboardchange"), object: nil)
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
        ["shift", "unshift", "123", "Abc", "sym", "space", "backspace", "return", "keyboardchange"].contains(key)
    }

    private var isColorSpecialKey: Bool {
        ["unshift", "123", "Abc", "sym", "backspace", "return", "keyboardchange"].contains(key)
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
            case "shift", "unshift":
                Image(systemName: "shift.fill")
                    .font(.system(size: 20))
            case "backspace":
                Image(systemName: "delete.left.fill")
                    .font(.system(size: 20))
            case "return":
                Image(systemName: "return")
                    .font(.system(size: 20))
            case "space":
                ZStack {
                    if keyboardState.showKeyboardName {
                        Text("Lisu")
                            .font(.system(size: 18))
                            .transition(.opacity.combined(with: .scale))
                    } else {
                        Text("space")
                            .font(.system(size: 18))
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .animation(.linear(duration: 0.5), value: keyboardState.showKeyboardName)
            case "keyboardchange":
                Image(systemName: "globe")
                    .font(.system(size: 20))
            case "123", "Abc", "sym":
                Text(key)
                    .font(.system(size: 16, weight: .medium))
            default:
                Text(key)
                    .font(.system(size: 20))
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
                    RoundedRectangle(cornerRadius: 8)
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
