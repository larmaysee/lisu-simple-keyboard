//
//  OrientationManager.swift
//  Lisu
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

class OrientationManager: ObservableObject {
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation {
        didSet {
            isLandscape = orientation.isLandscape
        }
    }
    
    @Published var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    init() {
        // Set initial orientation
        orientation = UIDevice.current.orientation
        isLandscape = orientation.isLandscape
        
        // Start monitoring device orientation
        NotificationCenter.default.addObserver(self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    @objc private func orientationDidChange() {
        DispatchQueue.main.async {
            self.orientation = UIDevice.current.orientation
        }
    }
}