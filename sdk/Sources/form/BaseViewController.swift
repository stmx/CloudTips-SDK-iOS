//
//  BaseViewController.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 30.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation

public class BaseViewController: UIViewController {
    let api = CloudtipsApi.init()
    
    var isKeyboardShowing: Bool = false
    var keyboardFrame: CGRect = .zero
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addLogoToNavigationBarItem()
        self.hideKeyboardWhenTappedAround()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)), name: UITextField.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: UITextField.keyboardWillHideNotification, object: nil)
    }
    
    @objc internal func onKeyboardWillShow(_ notification: Notification) {
        self.isKeyboardShowing = true
        self.keyboardFrame = (notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
    }
    
    @objc internal func onKeyboardWillHide(_ notification: Notification) {
        self.isKeyboardShowing = false
        self.keyboardFrame = .zero
    }
    
    @objc private func pop(){
        self.navigationController?.popViewController(animated: true)
    }
}
