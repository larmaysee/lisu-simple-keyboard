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
            .modifier(KeyboardHeightReader())
            .frame(height: calculateKeyboardHeight(geometry: geometry))
            .preference(
                key: KeyboardHeightPreferenceKey.self,
                value: geometry.size.height
            ).onPreferenceChange(KeyboardHeightPreferenceKey.self) { height in
                let kbHeight = calculateKeyboardHeight(geometry: geometry)
                onHeightChanged(
                    kbHeight
                )
            }
        }
    }
    
    private func calculateKeyboardHeight(geometry: GeometryProxy) -> CGFloat {
        let baseHeight = DeviceHelper.isIPad ? geometry.size.height * 0.3 : geometry.size.height * 0.4
        let height = DeviceHelper.isLandscape ?
            baseHeight * KeyboardConstants.heightRatioLandscape :
            baseHeight * KeyboardConstants.heightRatioPortrait
        let maxHeight = DeviceHelper.isIPad ? KeyboardConstants.iPadMaxHeight : KeyboardConstants.iOSMaxHeight
        let minHeight = DeviceHelper.isIPad ? KeyboardConstants.iPadMinHeight : KeyboardConstants.iOSMinHeight
        return min(max(height, minHeight), maxHeight)
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
}
