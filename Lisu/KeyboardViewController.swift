//
//  KeyboardViewController.swift
//  Lisu
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI
import UIKit

// MARK: - Keyboard Notification Names
enum KeyboardNotification {
    static let addKey = NSNotification.Name("addKey")
    static let deleteKey = NSNotification.Name("deleteKey")
    static let keyboardChange = NSNotification.Name("keyboardchange")
    static let returnKey = NSNotification.Name("return")
}

class KeyboardViewController: UIInputViewController, KeyboardViewDelegate {
    
    // MARK: - Properties
    private var heightConstraint: NSLayoutConstraint?
    private var keyboardView: UIView?
    private var hostingController: UIHostingController<KeyboardView>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom fonts
        FontHelper.registerFonts()

        // set up the keyboard
        setupKeyboardView()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         heightConstraint?.constant = DeviceHelper.getKeyboardHeight()

        guard let inputView = self.inputView else { return }
    
        // Dynamically update the hostingController's frame to match inputView's size
        hostingController?.view.frame = inputView.bounds
        
        // Update the layout
        hostingController?.view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Call super method
        super.viewWillTransition(to: size, with: coordinator)
        
        // Handle orientation change
        hostingController?.view.setNeedsLayout()
    }

    
    // MARK: - Setup Methods
    private func setupKeyboardView() {
        let orientationManager = OrientationManager()
        let viewModel = KeyboardViewModel()
            viewModel.delegate = self
        
        let keyboardView = KeyboardView(orientationManager: orientationManager, viewModel: viewModel)
        let hostingController = UIHostingController(rootView: keyboardView)
        
        hostingController.view.backgroundColor = .clear
        
        view.addSubview(hostingController.view)

        configureKeyboardConstraints(for: hostingController.view)
        
        self.keyboardView = hostingController.view
        self.hostingController = hostingController
        heightConstraint?.isActive = false
        heightConstraint = view.heightAnchor.constraint(equalToConstant: DeviceHelper.getKeyboardHeight())
        heightConstraint?.priority = .defaultHigh
        heightConstraint?.isActive = true

        hostingController.didMove(toParent: self)
    }
    
    private func configureKeyboardConstraints(for keyboardView: UIView) {
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func didTapKey(_ key: String) {
        textDocumentProxy.insertText(key)
    }
    
    func didTapReturn() {
        textDocumentProxy.insertText("\n")
    }

    func didTapBackspace() {
        textDocumentProxy.deleteBackward()
    }
    
    func ditTapKeyboardChange() {
       advanceToNextInputMode()
   }

    func handleOrientationChange() {
        heightConstraint?.constant = DeviceHelper.getKeyboardHeight()
        hostingController?.view.setNeedsLayout()
        hostingController?.view.layoutIfNeeded()
    }
    
    deinit {
        heightConstraint?.isActive = false
        heightConstraint = nil
    }
}


extension UIView {
    func addKeyboardSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leftAnchor.constraint(equalTo: leftAnchor),
            subview.rightAnchor.constraint(equalTo: rightAnchor),
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
