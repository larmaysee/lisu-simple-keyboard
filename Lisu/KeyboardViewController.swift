//
//  KeyboardViewController.swift
//  Lisu
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI
import UIKit

extension Notification.Name {
    static let keyboardHeightDidChange = Notification.Name("keyboardHeightDidChange")
}

class KeyboardViewController: UIInputViewController, KeyboardViewModelDelegate {
    
    private var heightConstraint: NSLayoutConstraint?
    private var hostingController: UIHostingController<KeyboardView>?
    private var keyboardView: UIView?
    private var keyboardViewModel = KeyboardViewModel()
    private var orientationManager = OrientationManager()  // ✅ Add orientation manager
    
    private var heightObserver: NSObjectProtocol?
    private var backspaceTimer: Timer?

    deinit {
        if let observer = heightObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardViewModel.delegate = self
        setupKeyboardView()
        setupHeightObservation()
        setupOrientationObservation()
    }
    
    private func setupHeightObservation() {
        if let observer = heightObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        heightObserver = NotificationCenter.default.addObserver(
            forName: .keyboardHeightDidChange,
            object: nil,
            queue: .main
        ) { notification in
            print("Received height notification")
            guard let height = notification.userInfo?["height"] as? CGFloat else {
                print("Invalid height value")
                return
            }
            
            print("height -- \(height)")
            
            self.updateHeightConstraint(height)
        }
    }
    
    private func updateHeightConstraint(_ height: CGFloat) {
        heightConstraint?.constant = height
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    
    private func setupKeyboardView() {
        let keyboardView = KeyboardView(
            viewModel: keyboardViewModel,
            onHeightChanged: { height in
                print("notification height change \(height)")
                
                NotificationCenter.default.post(
                    name: .keyboardHeightDidChange,
                    object: nil,
                    userInfo: ["height": height]
                )
            }
        )
        
        let hostingController = UIHostingController(rootView: keyboardView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hostingController.view)
        configureKeyboardConstraints(for: hostingController.view)
        
        self.keyboardView = hostingController.view
        self.hostingController = hostingController
        hostingController.didMove(toParent: self)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        print("Initial layout height: \(hostingController.view.frame.height)")
    }
    
    private func configureKeyboardConstraints(for keyboardView: UIView) {
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        // Initial height constraint (will be updated by notifications)
        heightConstraint = keyboardView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.priority = .defaultHigh
        heightConstraint?.isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hostingController?.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: heightConstraint?.constant ?? 0
        )
        
        print("Keyboard frame: \(view.frame)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.hostingController?.view.setNeedsLayout()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupOrientationObservation() {
        orientationManager.$isLandscape.sink { isLandscape in
            // Handle orientation change if needed
            print("Orientation changed: controller \(isLandscape ? "Landscape" : "Portrait")")
            self.updateHeightForOrientation(isLandscape: isLandscape)
            self.hostingController?.view.setNeedsLayout()
        }
    }
    
    private func updateHeightForOrientation(isLandscape: Bool) {
        let heightRatio = isLandscape ? KeyboardConstants.heightRatioLandscape : KeyboardConstants.heightRatioPortrait
        
        print("Height ratio: \(heightRatio)")
        
        let newHeight = view.bounds.height * heightRatio
        
        print("New height: \(newHeight)")
        updateHeightConstraint(newHeight)
    }
    
    func insertText(_ text: String) {
        textDocumentProxy.insertText(text)
    }
        
    func deleteBackward() {
        textDocumentProxy.deleteBackward()
    }
    
    func handleTab() {
        insertText("\t")
    }
    
    func handleUndo() {
//        textDocumentProxy.undo()
    }
    
    func handleRedo() {
//        textDocumentProxy.redo()
    }
    
    func handleReturn() {
        insertText("\n")
    }
    
    func handleKeyboardChange () {
        self.advanceToNextInputMode()
    }
}
