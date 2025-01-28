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
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            ForEach(layout.rows.indices, id: \.self) { rowIndex in
                KeyboardRow(
                    rowIndex: rowIndex,
                    layout: layout,
                    keyboardWidth: keyboardWidth,
                    keyboardHeight: keyboardHeight,
                    viewModel: viewModel
                )
            }
        }
        .padding(.vertical, KeyboardConstants.verticalPadding)
    }
    
    private func calculateRowWidth(row: [String]) -> CGFloat {
        let rowIndex = layout.rows.firstIndex(of: row) ?? 0
        let keysWidth = row.reduce(0) { result, key in
            let keyWidth = KeyboardLayoutHelper.getKeyWidth(for: key, totalWidth: keyboardWidth, rowKeys: row, rowIndex: rowIndex)
            return result + keyWidth
        }
        return keysWidth
    }
}

struct KeyboardRow: View {
    let rowIndex: Int
    let layout: KeyboardLayout
    let keyboardWidth: CGFloat
    let keyboardHeight: CGFloat
    let viewModel: KeyboardViewModel
    
    var body: some View {
        HStack(spacing: 0) {            
            ForEach(layout.rows[rowIndex], id: \.self) { key in
                createKeyButton(for: key)
            }
        }
    }
    
    private func calculateRowWidth() -> CGFloat {
        let row = layout.rows[rowIndex]
        let keysWidth = row.reduce(0) { result, key in
            let keyWidth = KeyboardLayoutHelper.getKeyWidth(
                for: key,
                totalWidth: keyboardWidth,
                rowKeys: row,
                rowIndex: rowIndex
            )
            return result + keyWidth
        }
        return keysWidth
    }
    
    private func getKeyAreaWidth(for key: String) -> CGFloat {
        let baseAreaWidth = KeyboardLayoutHelper.getKeyAreaWidth(totalWidth: keyboardWidth)
        
        // Special handling for 4th row (index 3)
        if rowIndex == 3 {
            let totalSpacing = KeyboardConstants.keySpacing * CGFloat(layout.rows[rowIndex].count)
            let usableWidth = keyboardWidth - totalSpacing
            let remainingKeys = CGFloat(layout.rows[rowIndex].count - 1)
            
            if key == "Space" {
                // Space takes 40% of usable width plus spacing
                return (usableWidth * 0.4) + KeyboardConstants.keySpacing
            } else {
                // Other keys share the remaining 60% equally plus spacing
                let remainingWidth = usableWidth * 0.6
                return (remainingWidth / remainingKeys) + KeyboardConstants.keySpacing
            }
        }
        
        // Special handling for first and last keys in rows 1 and 2
        if (rowIndex == 1 || rowIndex == 2) && 
           (layout.rows[rowIndex].first == key || layout.rows[rowIndex].last == key) && layout.rows[rowIndex].count < KeyboardConstants.maxKeysPerRow {
            return baseAreaWidth + (baseAreaWidth / 2)
        }
        
        return baseAreaWidth
    }
    
    private func createKeyButton(for key: String) -> some View {
        let keyWidth = KeyboardLayoutHelper.getKeyWidth(
            for: key,
            totalWidth: keyboardWidth,
            rowKeys: layout.rows[rowIndex],
            rowIndex: rowIndex
        )
        
        let keyHeight = KeyboardLayoutHelper.getKeyHeight(totalHeight: keyboardHeight)
        let keyAreaWidth = getKeyAreaWidth(for: key)
        let keyAreaHeight = KeyboardLayoutHelper.getKeyAreaHeight(totalHeight: keyboardHeight)
        
        return KeyButton(
            viewModel: viewModel,
            key: key,
            width: keyWidth,
            height: keyHeight,
            areaWidth: keyAreaWidth,
            areaHeight: keyAreaHeight,
            rowIndex: rowIndex,
            rowKeys: layout.rows[rowIndex],
            layout: layout
        )
    }
}
