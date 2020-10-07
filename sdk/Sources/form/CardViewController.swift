//
//  InputCardDataViewController.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 29.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import UIKit
import Cloudpayments_SDK_iOS
import WebKit

class CardViewController: BasePaymentViewController, AuthDelegate {
    @IBOutlet private weak var cardNumberTextField: UnderlineTextField!
    @IBOutlet private weak var cardExpDateTextField: UnderlineTextField!
    @IBOutlet private weak var cardCvcTextField: UnderlineTextField!
    @IBOutlet private weak var progressView: ProgressView!
    @IBOutlet weak var payButton: Button!
    
    private var threeDsView: UIView?
    
    
    var amount = "0"
    var comment = ""
    var layoutId: String!
    
    private let threeDsProcessor = ThreeDsProcessor()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.validate()
        self.prepareUI()
    }
    
    private func prepareUI(){
        self.progressView.bgColor = UIColor.white.withAlphaComponent(0.5)
        
        self.payButton.onAction = {
            self.pay()
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
    
    private func pay() {
        self.showProgress()
        self.getPublicId(with: self.layoutId) { (publicId, error) in
            if let publicId = publicId, let cryptogram = Card.makeCardCryptogramPacket(with: self.cardNumberTextField.text!, expDate: self.cardExpDateTextField.text!, cvv: self.cardCvcTextField.text!, merchantPublicID: publicId) {
                let paymentData = PaymentData.init(layoutId: self.layoutId, cryptogram: cryptogram, comment: self.comment, amount: self.amount)
                self.auth(with: paymentData) { (response, error) in
                    self.hideProgress()
                    if let response = response {
                        if response.status == .need3ds, let acsUrl = response.acsUrl, let md = response.md, let paReq = response.paReq {
                            self.showThreeDs(with: acsUrl, md: md, paReq: paReq)
                        } else if response.status == .success {
                            self.onPaymentSucceeded()
                        } else if response.status == .failure {
                            let ctError = CloudtipsError.init(message: response.message ?? "Ошибка")
                            self.onPaymentFailed(with: ctError)
                        }
                    } else {
                        let ctError = CloudtipsError.init(message: error?.localizedDescription ?? "Ошибка")
                        self.onPaymentFailed(with: ctError)
                    }
                }
            } else {
                self.hideProgress()
            }
        }
    }
    
    private func showThreeDs(with acsUrl: String, md: String, paReq: String) {
        let threeDsData = ThreeDsData.init(transactionId: md, paReq: paReq, acsUrl: acsUrl)
        self.threeDsProcessor.make3DSPayment(with: threeDsData, delegate: self)
    }
    
    private func showProgress() {
        self.progressView.startAnimation()
        
        self.progressView.alpha = 0
        self.progressView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.progressView.alpha = 1
        }
    }
    
    private func hideProgress() {
        UIView.animate(withDuration: 0.25) {
            self.progressView.alpha = 0
        } completion: { (status) in
            self.progressView.isHidden = true
            self.progressView.stopAnimation()
        }
    }
}

extension CardViewController: ThreeDsDelegate {
    func willPresentWebView(_ webView: WKWebView) {
        if let view = self.navigationController?.view {
            let threeDsContainerView = UIView.init(frame: view.bounds)
            threeDsContainerView.translatesAutoresizingMaskIntoConstraints = false
            threeDsContainerView.backgroundColor = .white
            view.addSubview(threeDsContainerView)
            threeDsContainerView.bindFrameToSuperviewBounds()
            
            let headerView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: threeDsContainerView.frame.width, height: 56)))
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.backgroundColor = .veryLightBlue
            
            headerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
            headerView.layer.shadowRadius = 4.0
            headerView.layer.shadowOffset = CGSize.init(width: 0, height: -2)
            headerView.layer.shadowOpacity = 0.5
            headerView.layer.shadowPath = UIBezierPath(rect: headerView.bounds).cgPath
            headerView.layer.masksToBounds = false
            
            threeDsContainerView.addSubview(headerView)
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: threeDsContainerView.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: threeDsContainerView.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: threeDsContainerView.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 56)
            ])
            
            let closeButton = UIButton.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 56, height: 56)))
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.setImage(UIImage.named("ic_close"), for: .normal)
            closeButton.addTarget(self, action: #selector(onCloseThreeDs(_:)), for: .touchUpInside)
            headerView.addSubview(closeButton)
            NSLayoutConstraint.activate([
                closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                closeButton.heightAnchor.constraint(equalToConstant: 56),
                closeButton.widthAnchor.constraint(equalToConstant: 56)
            ])
            
            webView.frame = threeDsContainerView.bounds
            webView.translatesAutoresizingMaskIntoConstraints = false
            threeDsContainerView.addSubview(webView)
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                webView.leadingAnchor.constraint(equalTo: threeDsContainerView.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: threeDsContainerView.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: threeDsContainerView.bottomAnchor)
            ])
            
            threeDsContainerView.bringSubviewToFront(webView)
            
            threeDsContainerView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                threeDsContainerView.alpha = 1
            }
            
            self.threeDsView = threeDsContainerView
        }
    }
    
    func onAuthotizationCompleted(with md: String, paRes: String) {
        self.hideThreeDs()
        self.showProgress()
        
        self.post3ds(md: md, paRes: paRes) { (response, error) in
            self.hideProgress()
            if let response = response {
                if response.status == .success {
                    self.onPaymentSucceeded()
                } else {
                    let error = CloudtipsError.init(message: response.message ?? "Ошибка")
                    self.onPaymentFailed(with: error)
                }
            } else {
                let error = CloudtipsError.init(message: error?.localizedDescription ?? "Ошибка")
                self.onPaymentFailed(with: error)
            }
        }
    }
    
    func onAuthorizationFailed(with html: String) {
        self.hideThreeDs()
        self.hideProgress()
        
        let error = CloudtipsError.init(message: html)
        self.onPaymentFailed(with: error)
    }
    
    @objc private func onCloseThreeDs(_ sender: UIButton) {
        self.hideThreeDs()
    }
    
    private func hideThreeDs(){
        UIView.animate(withDuration: 0.3) {
            self.threeDsView?.alpha = 0
        } completion: { (status) in
            self.threeDsView?.removeFromSuperview()
            self.threeDsView = nil
        }

    }
}
