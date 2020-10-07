//
//  ViewController.swift
//  Cloudtips-SDK-iOS-Demo
//
//  Created by Sergey Iskhakov on 29.09.2020.
//

import UIKit
import Cloudtips_SDK_iOS

class ViewController: UIViewController {
    @IBOutlet private weak var textField: UnderlineTextField!
    @IBOutlet private weak var continueButton: Button!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.didChange = {
            if let text = self.textField.text {
                self.textField.text = text.formattedPhoneNumber()
            }
            
            self.validate()
        }
        
        self.validate()
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
            TipsViewController.present(with: "+" + text, name: "Тестовый пользователь Demo", from: self)
        }
    }
}

