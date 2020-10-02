//
//  InputCardDataViewController.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 29.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import UIKit

class CardViewController: BaseViewController {
    @IBOutlet private weak var cardNumberTextField: UnderlineTextField!
    @IBOutlet private weak var cardExpDateTextField: UnderlineTextField!
    @IBOutlet private weak var cardCvcTextField: UnderlineTextField!
    @IBOutlet weak var payButton: Button!
    
    var amount = "0"
    var comment = ""
    var layoutId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
    }
    
    private func prepareUI(){
        self.payButton.onAction = {
            self.performSegue(withIdentifier: .cardToResultSegue, sender: self)
        }
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainText]
        self.cardNumberTextField.attributedPlaceholder = NSAttributedString.init(string: "Номер карты", attributes: attributes)
        self.cardExpDateTextField.attributedPlaceholder = NSAttributedString.init(string: "ММ/ГГ", attributes: attributes)
        self.cardCvcTextField.attributedPlaceholder = NSAttributedString.init(string: "CVC", attributes: attributes)
        
        self.cardNumberTextField.didChange = {
            if let cardNumber = self.cardNumberTextField.text?.formattedCardNumber() {
                self.cardNumberTextField.text = cardNumber
                
                if cardNumber.cardNumberIsValid() {
                    self.cardExpDateTextField.becomeFirstResponder()
                }
                
                self.updatePaymentSystemIcon(cardNumber: cardNumber)
                
                self.validate()
            }
        }
        
        self.cardExpDateTextField.didChange = {
            if let cardExp = self.cardExpDateTextField.text?.formattedCardExp() {
                self.cardExpDateTextField.text = cardExp
                
                if cardExp.count == 5 {
                    self.cardCvcTextField.becomeFirstResponder()
                }
                
                self.validate()
            }
        }

        self.cardCvcTextField.didChange = {
            if let text = self.cardCvcTextField.text?.formattedCardCVV() {
                self.cardCvcTextField.text = text
                
                if text.count == 3 {
                    self.cardCvcTextField.resignFirstResponder()
                }
                
                self.validate()
            }
        }
        
        self.cardNumberTextField.shouldReturn = {
            if let cardNumber = self.cardNumberTextField.text?.formattedCardNumber() {
                if cardNumber.cardNumberIsValid() {
                    self.cardExpDateTextField.becomeFirstResponder()
                }
            }
            return false
        }
        
        self.cardExpDateTextField.shouldReturn = {
            if let cardExp = self.cardExpDateTextField.text?.formattedCardExp() {
                if cardExp.count == 5 {
                    self.cardCvcTextField.becomeFirstResponder()
                }
            }
            
            return false
        }

        self.cardCvcTextField.shouldReturn = {
            if let text = self.cardCvcTextField.text?.formattedCardCVV() {
                if text.count == 3 {
                    self.cardCvcTextField.resignFirstResponder()
                }
            }
            
            return false
        }
    }
    
    private func validate() {
        let cardNumberIsValid = self.cardNumberTextField.text?.formattedCardNumber().cardNumberIsValid() == true
        let cardExpIsValid = self.cardExpDateTextField.text?.formattedCardExp().count == 5
        let cardCvcIsValid = self.cardCvcTextField.text?.formattedCardCVV().count == 3
        
        self.payButton.isEnabled = cardNumberIsValid && cardExpIsValid && cardCvcIsValid
    }
    
    private func updatePaymentSystemIcon(cardNumber: String?){
//        if let number = cardNumber {
//            let cardType = Card.cardType(from: number)
//            if cardType != .unknown {
//                self.cardTypeIcon.image = cardType.getIcon()
//                self.cardTypeIcon.isHidden = false
//                self.scanButton.isHidden = true
//            } else {
//                self.cardTypeIcon.isHidden = true
//                self.scanButton.isHidden = self.paymentData.scanner == nil
//            }
//        } else {
//            self.cardTypeIcon.isHidden = true
//            self.scanButton.isHidden = self.paymentData.scanner == nil
//        }
    }
}
