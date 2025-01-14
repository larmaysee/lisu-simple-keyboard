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
    @IBOutlet var nextKeyboardButton: UIButton!
    private var heightConstraint: NSLayoutConstraint?
    private var keyboardView: UIView?
    private var hostingController: UIHostingController<KeyboardView>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
        setupNextKeyboardButton()
        setupNotificationObservers()
        setupTraitChangeObserver()
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
    
    // MARK: - Setup Methods
    private func setupTraitChangeObserver() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitHorizontalSizeClass.self, UITraitVerticalSizeClass.self]) { (self: KeyboardViewController, _) in
                self.view.frame.size.height = DeviceHelper.getKeyboardHeight()
            }
        }
    }
    
    private func setupKeyboardView() {
        let keyboardView = KeyboardView()
        let hostingController = UIHostingController(rootView: keyboardView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        configureKeyboardConstraints(for: hostingController.view)
        
        self.keyboardView = hostingController.view
        self.hostingController = hostingController
        
        heightConstraint = view.heightAnchor.constraint(equalToConstant: DeviceHelper.getKeyboardHeight())
        heightConstraint?.isActive = true
    }
    
    private func configureKeyboardConstraints(for view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
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
        let notificationCenter = NotificationCenter.default
        
        // Keyboard input notifications
        notificationCenter.addObserver(self, selector: #selector(handleAddKey), name: KeyboardNotification.addKey, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleDeleteKey), name: KeyboardNotification.deleteKey, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardChange), name: KeyboardNotification.keyboardChange, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleReturn), name: KeyboardNotification.returnKey, object: nil)
        
        // Device orientation notification
        notificationCenter.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Keyboard Input Handlers
    @objc private func handleAddKey(_ notification: Notification) {
        guard let text = notification.object as? String else { return }
        textDocumentProxy.insertText(text)
    }
    
    @objc private func handleDeleteKey(_ notification: Notification) {
        textDocumentProxy.deleteBackward()
    }
    
    @objc private func handleKeyboardChange(_ notification: Notification) {
        guard let type = notification.object as? String else { return }
        textDocumentProxy.insertText(type)
    }
    
    @objc private func handleReturn(_ notification: Notification) {
        textDocumentProxy.insertText("\n")
    }
    
    @objc private func orientationDidChange() {
        heightConstraint?.constant = DeviceHelper.getKeyboardHeight()
    }
}

// MARK: - Appearance Methods
extension KeyboardViewController {
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        updateNextKeyboardButtonVisibility()
        updateNextKeyboardButtonColor()
    }
    
    private func updateNextKeyboardButtonVisibility() {
        nextKeyboardButton.isHidden = DeviceHelper.isIPad() ? true : !needsInputModeSwitchKey
    }
    
    private func updateNextKeyboardButtonColor() {
        let textColor = textDocumentProxy.keyboardAppearance == .dark ? UIColor.white : UIColor.black
        nextKeyboardButton.setTitleColor(textColor, for: [])
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
