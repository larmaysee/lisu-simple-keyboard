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
    @ObservedObject var viewModel: KeyboardViewModel
    @State private var isLandscape: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let layout = keyboardState.getCurrentLayout()
            let keyboardWidth = geometry.size.width
            let keyboardHeight = geometry.size.height
            
            if keyboardWidth > 0 && keyboardHeight > 0 {
                VStack(spacing: 0) {
                    ZStack {
                        KeyboardContentView(
                            keyboardWidth: keyboardWidth,
                            keyboardHeight: keyboardHeight,
                            layout: layout,
                            keyboardState: keyboardState,
                            viewModel: viewModel
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: isLandscape) { oldValue, newValue in
                    if oldValue != newValue {
                        updateOrientation(UIDevice.current.orientation)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            updateOrientation(UIDevice.current.orientation)
        }
    }
    
    private func isSpecialKey(_ key: String) -> Bool {
        return ["Shift", "Unshift", "?123", "ꓐꓑꓒ", "=\\<", "Space", "Backspace", "Return", "Keyboardchange"].contains(key)
    }
    
    private func calculateHorizontalOffset(rowIndex: Int, showingKey: String, layout: KeyboardLayout, geometry: GeometryProxy) -> CGFloat {
        let regularKeyWidth = KeyboardLayoutHelper.getKeyWidth(
            for: "A",
            totalWidth: geometry.size.width,
            rowKeys: layout.rows[0],
            rowIndex: 0
        )
        
        switch rowIndex {
        case 1:
            let keyDiff = layout.rows[0].count - layout.rows[1].count
            return (CGFloat(keyDiff) * regularKeyWidth) / 2.0
        case 2:
            if showingKey == "Backspace" || showingKey == "Shift" || showingKey == "Unshift" {
                return 0
            } else {
                return regularKeyWidth * 0.25
            }
        default:
            return 0
        }
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
        
        for buttonKey in row {
            let buttonWidth = KeyboardLayoutHelper.getKeyWidth(
                for: buttonKey,
                totalWidth: keyboardWidth,
                rowKeys: row,
                rowIndex: rowIndex
            )
            
            if buttonKey == key {
                return CGRect(
                    x: currentX,
                    y: currentY,
                    width: buttonWidth,
                    height: KeyboardLayoutHelper.getKeyHeight(totalHeight: geometry.size.height)
                )
            }
            
            currentX += buttonWidth + KeyboardConstants.keySpacing
        }
        
        return .zero
    }
    
    private func updateOrientation(_ orientation: UIDeviceOrientation) {
        isLandscape = orientation.isLandscape
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
