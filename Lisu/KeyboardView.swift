//
//  KeyboardView.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

struct KeyboardView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: KeyboardViewModel
    let onHeightChanged: (CGFloat) -> Void
    
    @ObservedObject var orientationManager = OrientationManager()  // ✅ Add orientation manager

    private var isIPad: Bool { DeviceHelper.isIPad }
    private var isLandscape: Bool { DeviceHelper.isLandscape }
    
    var body: some View {
        GeometryReader { geometry in
            Spacer(minLength: 0)
            VStack(
                spacing: 0
            ) {
                Spacer()
                ForEach(currentLayout.rows.indices, id: \.self) { index in
                    KeyboardRow(
                        keys: currentLayout.rows[index],
                        viewModel: viewModel,
                        isIPad: DeviceHelper.isIPad,
                        rowIndex: index
                    )
                }
            }
            .frame(height: calculateKeyboardHeight(geometry: geometry))
            .modifier(KeyboardHeightReader())
            .preference(
                key: KeyboardHeightPreferenceKey.self,
                value: geometry.size.height
            ).onPreferenceChange(KeyboardHeightPreferenceKey.self) { height in
                print("on preference height: \(height)")
                
                let kbHeight = calculateKeyboardHeight(geometry: geometry)
                print("kbHeight: \(kbHeight)")
                onHeightChanged(
                    kbHeight
                )
            }
            .onReceive(orientationManager.$isLandscape) { isLandscape in
                // Handle orientation change if needed
                print("Orientation changed: \(isLandscape ? "Landscape" : "Portrait")")
            }
        }
    }
    
    private func calculateKeyboardHeight(geometry: GeometryProxy) -> CGFloat {
        let baseHeight = DeviceHelper.isIPad ? geometry.size.height * 0.3 : geometry.size.height * 0.4
        let height = DeviceHelper.isLandscape ?
            baseHeight * KeyboardConstants.heightRatioLandscape :
            baseHeight * KeyboardConstants.heightRatioPortrait
        let maxHeight = getMaxKeyboardHeight()
        let minHeight = getMinKeyboardHeight()
        let newHeight  = min(max(height, minHeight), maxHeight)
        return newHeight
    }
    
    private var currentLayout: KeyboardLayout {
        KeyboardLayoutConfig.getLayout(
            for: viewModel.keyboardState,
            device: isIPad ? .ipad : .iphone
        )
    }
    
    private var background: some View {
        colorScheme == .dark ?
        KeyboardConstants.darkKeyboardBackground :
        KeyboardConstants.lightKeyboardBackground
    }
    
    private func getMaxKeyboardHeight() -> CGFloat {
        isIPad ? (isLandscape ? KeyboardConstants.iPadLandscapeMaxHeight : KeyboardConstants.iPadMaxHeight) :
            (isLandscape ? KeyboardConstants.iOSLandscapeMaxHeight : KeyboardConstants.iOSMaxHeight)
    }
    
    private func getMinKeyboardHeight() -> CGFloat {
        isIPad ? (isLandscape ? KeyboardConstants.iPadLandscapeMinHeight : KeyboardConstants.iPadMinHeight) :
        (isLandscape ? KeyboardConstants.iOSLandscapeMinHeight : KeyboardConstants.iOSMinHeight)
    }
}
