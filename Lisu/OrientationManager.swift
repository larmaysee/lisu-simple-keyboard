//
//  KeyboardViewController.swift
//  Lisu
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

class OrientationManager: ObservableObject {
    @Published var orientation: UIDeviceOrientation = .portrait
}