//
//  KeyboardViewController.swift
//  Lisu
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

// MARK: - Keyboard Notification Names
enum KeyboardNotification {
    static let addKey = NSNotification.Name("addKey")
    static let deleteKey = NSNotification.Name("deleteKey")
    static let keyboardChange = NSNotification.Name("keyboardchange")
    static let returnKey = NSNotification.Name("return")
}

class KeyboardViewController: UIInputViewController {
    
    // MARK: - Properties
    private var heightConstraint: NSLayoutConstraint?
    private var keyboardView: UIView?
    private var hostingController: UIHostingController<KeyboardView>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register custom fonts
        FontHelper.registerFonts()
        
        for family in UIFont.familyNames {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("Font: \(name)")
            }
        }
        
        setupNotificationObservers()
        setupKeyboardView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         heightConstraint?.constant = DeviceHelper.getKeyboardHeight()

        guard let inputView = self.inputView else { return }
    
        // Dynamically update the hostingController's frame to match inputView's size
        hostingController?.view.frame = inputView.bounds
        hostingController?.view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        hostingController?.view.setNeedsLayout()
    }
    
    // MARK: - Setup Methods
    private func setupKeyboardView() {
        let orientationManager = OrientationManager()
        let keyboardView = KeyboardView(orientationManager: orientationManager)
        let hostingController = UIHostingController(rootView: keyboardView)
        
        hostingController.view.backgroundColor = .clear
        
        view.addSubview(hostingController.view)

        configureKeyboardConstraints(for: hostingController.view)
        
        self.keyboardView = hostingController.view
        self.hostingController = hostingController
        heightConstraint = view.heightAnchor.constraint(equalToConstant: DeviceHelper.getKeyboardHeight())
        heightConstraint?.isActive = true
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

    private func setupNotificationObservers() {
        let notificationCenter = NotificationCenter.default
        
        // Keyboard input notifications
        notificationCenter.addObserver(self, selector: #selector(handleKeyPress(_:)), name: KeyboardNotification.addKey, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleDelete), name: KeyboardNotification.deleteKey, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleReturn(_:)), name: KeyboardNotification.returnKey, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardChange), name: KeyboardNotification.keyboardChange, object: nil)
        // Orientation change notification
        notificationCenter.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc private func handleOrientationChange() {
        heightConstraint?.constant = DeviceHelper.getKeyboardHeight()
        hostingController?.view.setNeedsLayout()
        hostingController?.view.layoutIfNeeded()
    }

    // MARK: - Keyboard Input Handlers
    @objc private func handleKeyPress(_ notification: Notification) {
        guard let text = notification.object as? String else { return }
        textDocumentProxy.insertText(text)
        SoundManager.shared.playKeyClick()
    }
    
    @objc private func handleDelete() {
        textDocumentProxy.deleteBackward()
        SoundManager.shared.playKeyClick()
    }
    
    @objc private func handleReturn(_ notification: Notification) {
        textDocumentProxy.insertText("\n")
        SoundManager.shared.playKeyClick()
    }
    
    @objc private func handleKeyboardChange() {
        advanceToNextInputMode()
        SoundManager.shared.playKeyClick()
    }

    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: KeyboardNotification.addKey, object: nil)
        notificationCenter.removeObserver(self, name: KeyboardNotification.deleteKey, object: nil)
        notificationCenter.removeObserver(self, name: KeyboardNotification.returnKey, object: nil)
        notificationCenter.removeObserver(self, name: KeyboardNotification.keyboardChange, object: nil)
        notificationCenter.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
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
