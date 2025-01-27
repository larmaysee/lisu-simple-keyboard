//  KeyboardContentView.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 27/01/2025.
//  Copyright 2025 Lar May See. All rights reserved.
//

import SwiftUI

struct KeyboardContentView: View {
    let keyboardWidth: CGFloat
    let keyboardHeight: CGFloat
    let layout: KeyboardLayout
    @ObservedObject var keyboardState: KeyboardState
    @StateObject var viewModel: KeyboardViewModel

    var body: some View {
        VStack(spacing: KeyboardConstants.rowSpacing) {
            Spacer(minLength: 0)
            ForEach(layout.rows.indices, id: \.self) { rowIndex in
                HStack {
                    let rowWidth = calculateRowWidth(row: layout.rows[rowIndex])
                    Spacer(minLength: (keyboardWidth - rowWidth) / 2)
                    ForEach(layout.rows[rowIndex], id: \.self) { key in
                        let keyWidth = KeyboardLayoutHelper.getKeyWidth(for: key, totalWidth: keyboardWidth, rowKeys: layout.rows[rowIndex], rowIndex: rowIndex)
                        if rowIndex == 2 && willAddPrefixSpace(key: key) {
                            Spacer().frame(width: (keyWidth * 0.25) - KeyboardConstants.keySpacing)
                        }

                        KeyButton(
                            viewModel: viewModel,
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
        .padding(.vertical, KeyboardConstants.verticalPadding)
    }
    
    private func calculateRowWidth(row: [String]) -> CGFloat {
        let rowIndex = layout.rows.firstIndex(of: row) ?? 0
        let keysWidth = row.reduce(0) { result, key in
            let keyWidth = KeyboardLayoutHelper.getKeyWidth(for: key, totalWidth: keyboardWidth, rowKeys: row, rowIndex: rowIndex)
            
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
        return ["Shift", "Unshift", "?123", "=\\<"].contains(key)
    }
}
