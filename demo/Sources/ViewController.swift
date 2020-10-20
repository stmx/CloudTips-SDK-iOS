//
//  ViewController.swift
//  Cloudtips-SDK-iOS-Demo
//
//  Created by Sergey Iskhakov on 29.09.2020.
//

import UIKit
import Cloudtips

class ViewController: UIViewController {
    @IBOutlet private weak var textField: TextField!
    @IBOutlet private weak var continueButton: Button!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.didChange = {
            if let text = self.textField.text {
                self.textField.text = text.formattedPhoneNumber()
            }
            
            self.validate()
        }
//        self.textField.text = "79176114775".formattedPhoneNumber()
        self.validate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    private func validate(){
        if let text = self.textField.text?.phoneNumber(), text.count == 11 {
            self.continueButton.isEnabled = true
        } else {
            self.continueButton.isEnabled = false
        }
    }

    @IBAction func onContinue(_ sender: UIButton) {
        if let text = self.textField.text?.phoneNumber() {
            let configuration = TipsConfiguration.init(phoneNumber: "+" + text, userName: "Cloudtips demo user")
            configuration.setApplePayMerchantId("merchant.ru.cloudpayments")
            TipsViewController.present(with: configuration, from: self)
        }
    }
}

