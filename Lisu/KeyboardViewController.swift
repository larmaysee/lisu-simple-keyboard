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
    private var keyboardView: UIView?
    private var hostingController: UIHostingController<KeyboardView>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
        setupNextKeyboardButton()
        setupNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let inputView = self.view as? UIInputView {
            // Ensure the keyboard has the correct height
            self.view.frame.size = inputView.frame.size
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update hosting controller view frame
        hostingController?.view.frame = view.bounds
    }
    
    // MARK: - Setup Methods
    private func setupKeyboardView() {
        let orientationManager = OrientationManager()
        let keyboardView = KeyboardView(orientationManager: orientationManager)
        let hostingController = UIHostingController(rootView: keyboardView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        configureKeyboardConstraints(for: hostingController.view)
        
        self.keyboardView = hostingController.view
        self.hostingController = hostingController

        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
            orientationManager.orientation = UIDevice.current.orientation
        }
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
        notificationCenter.addObserver(self, selector: #selector(handleKeyPress(_:)), name: KeyboardNotification.addKey, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleDelete), name: KeyboardNotification.deleteKey, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleReturn(_:)), name: KeyboardNotification.returnKey, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardChange), name: KeyboardNotification.keyboardChange, object: nil)
        // Orientation change notification
        notificationCenter.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc private func handleOrientationChange() {
        let orientation = UIDevice.current.orientation
        adjustKeyboardLayout(for: orientation)
    }

    private func adjustKeyboardLayout(for orientation: UIDeviceOrientation) {
        UIView.animate(withDuration: 0.3) {
            if orientation.isLandscape {
                print("Landscape mode detected")
                self.hostingController?.view?.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            } else if orientation.isPortrait {
                print("Portrait mode detected")
                self.hostingController?.view?.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
            }
        }
        
        print("Orientation: \(orientation)")
        
        // Notify your SwiftUI view if necessary
        hostingController?.rootView.updateOrientation(orientation)
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
