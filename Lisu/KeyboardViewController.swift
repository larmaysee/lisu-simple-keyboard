//
//  KeyboardViewController.swift
//  Lisu
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    private var heightConstraint: NSLayoutConstraint?
    private var keyboardView: UIView?
    private var hostingController: UIHostingController<KeyboardView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
        setupNextKeyboardButton()
        setupNotificationObservers()
        
        // Register for trait changes
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitHorizontalSizeClass.self, UITraitVerticalSizeClass.self]) { (self: KeyboardViewController, _) in
                self.view.frame.size.height = DeviceHelper.getKeyboardHeight()
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAddKey(_:)),
            name: NSNotification.Name("addKey"),
            object: nil
        )
        
        // Delete key notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeleteKey(_:)),
            name: NSNotification.Name("deleteKey"),
            object: nil
        )
        
        // Keyboard change notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardChange(_:)),
            name: NSNotification.Name("keyboardchange"),
            object: nil
        )
        
        // Return key notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReturn(_:)),
            name: NSNotification.Name("return"),
            object: nil
        )
    }
    
    private func setupKeyboardView() {
        let keyboardView = KeyboardView()
        let hostingController = UIHostingController(rootView: keyboardView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Setup constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            hostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.keyboardView = hostingController.view
        self.hostingController = hostingController
        
        // Set initial height
        heightConstraint = view.heightAnchor.constraint(equalToConstant: DeviceHelper.getKeyboardHeight())
        heightConstraint?.isActive = true
    }
    
    private func setupNextKeyboardButton() {
        nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        view.addSubview(nextKeyboardButton)
        
        NSLayoutConstraint.activate([
            nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            nextKeyboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    private func updateNextKeyboardButtonVisibility() {
        if DeviceHelper.isIPad() {
            // Always hide the button on iPad
            self.nextKeyboardButton.isHidden = true
        } else {
            // On iPhone, show based on system needs
            self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        heightConstraint?.constant = DeviceHelper.getKeyboardHeight()
        updateNextKeyboardButtonVisibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNextKeyboardButtonVisibility()
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        updateNextKeyboardButtonVisibility()
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    @objc private func handleAddKey(_ notification: Notification) {
        if let text = notification.object as? String {
            textDocumentProxy.insertText(text)
        }
    }
    
    @objc private func handleDeleteKey(_ notification: Notification) {
        textDocumentProxy.deleteBackward()
    }
    
    @objc private func handleKeyboardChange(_ notification: Notification) {
        advanceToNextInputMode()
    }
    
    @objc private func handleReturn(_ notification: Notification) {
        textDocumentProxy.insertText("\n")
    }
    
    @objc private func orientationDidChange() {
        view.setNeedsLayout()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
