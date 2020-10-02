//
//  TipsViewController.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 29.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import UIKit
import SDWebImage
import PassKit

public class TipsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet private weak var progressView: ProgressView!
    @IBOutlet private weak var contentScrollView: UIScrollView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var purposeLabel: UILabel!
    @IBOutlet private weak var amountTextField: UnderlineTextField!
    @IBOutlet private weak var amountsCollectionView: UICollectionView!
    @IBOutlet private weak var commentTextField: UnderlineTextField!
    @IBOutlet private weak var applePayButtonContainer: UIView!
    @IBOutlet private weak var payButton: Button!
    @IBOutlet private weak var eulaButton: Button!
    
    private var supportedPaymentNetworks: [PKPaymentNetwork] {
        get {
            var arr: [PKPaymentNetwork] = [.visa, .masterCard, .JCB]
            if #available(iOS 12.0, *) {
                arr.append(.maestro)
            }
            
            return arr
        }
    }
    
    private let defaultAmounts = [100, 200, 300, 500, 1000, 2000, 3000, 5000]
    
    private var phoneNumber = ""
    private var name: String?
    
    private var layout: Layout?
    private var profile: Profile?
    
    public class func present(with phoneNumber: String, name: String?, from: UIViewController) {
        let navController = UIStoryboard.init(name: "Main", bundle: Bundle.mainSdk).instantiateInitialViewController() as! UINavigationController
        let controller = navController.topViewController as! TipsViewController
        controller.phoneNumber = phoneNumber
        controller.name = name
        
        from.present(navController, animated: true, completion: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        self.prepareUI()
        
        self.updateLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.progressView.isHidden {
            self.progressView.startAnimation()
        } else {
            self.progressView.stopAnimation()
        }
    }
    
    private func initializeApplePay() {
        if PKPaymentAuthorizationViewController.canMakePayments() {
            let button: PKPaymentButton
            if PKPaymentAuthorizationController.canMakePayments(usingNetworks: self.supportedPaymentNetworks) {
                button = PKPaymentButton.init(paymentButtonType: .plain, paymentButtonStyle: .black)
                button.addTarget(self, action: #selector(onApplePay(_:)), for: .touchUpInside)
            } else {
                button = PKPaymentButton.init(paymentButtonType: .setUp, paymentButtonStyle: .black)
                button.addTarget(self, action: #selector(onSetupApplePay(_:)), for: .touchUpInside)
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            button.cornerRadius = 4
            
            self.applePayButtonContainer.isHidden = false
            self.applePayButtonContainer.addSubview(button)
            button.bindFrameToSuperviewBounds()
        } else {
            self.applePayButtonContainer.isHidden = true
        }
    }
    
    @objc private func onApplePay(_ sender: UIButton) {
//        let amount = Double(self.paymentData.amount) ?? 0.0
//
//        let request = PKPaymentRequest()
//        request.merchantIdentifier = self.paymentData.applePayMerchantId
//        request.supportedNetworks = self.supportedPaymentNetworks
//        request.merchantCapabilities = PKMerchantCapability.capability3DS
//        request.countryCode = "RU"
//        request.currencyCode = self.paymentData.currency.rawValue
//        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "К оплате", amount: NSDecimalNumber.init(value: amount))]
//        if let applePayController = PKPaymentAuthorizationViewController(paymentRequest:
//                request) {
//            applePayController.delegate = self
//            applePayController.modalPresentationStyle = .formSheet
//            self.present(applePayController, animated: true, completion: nil)
//        }
    }
    
    @objc private func onSetupApplePay(_ sender: UIButton) {
        PKPassLibrary().openPaymentSetup()
    }
    
    private func updateLayout() {
        self.contentScrollView.isHidden = true
        self.progressView.isHidden = false
        
        self.api.getLayout(by: self.phoneNumber) { [weak self] (layouts, error) in
            guard let `self` = self else {
                return
            }
            
            self.checkLayouts(layouts: layouts, error: error, createIfEmpty: true)
        }
    }
    
    private func checkLayouts(layouts: [Layout]?, error: Error?, createIfEmpty: Bool) {
        if let layout = layouts?.first {
            self.layout = layout
            
            if let layoutId = layout.layoutId {
                self.getProfile(by: layoutId) { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.contentScrollView.isHidden = false
                    self.progressView.isHidden = true
                    self.progressView.stopAnimation()
                    
                    self.updateUI()
                }
            }
        } else if createIfEmpty && layouts?.isEmpty == true {
            self.api.offlineRegister(with: self.phoneNumber, name: self.name) { [weak self] (layouts, error) in
                guard let `self` = self else {
                    return
                }
                
                self.checkLayouts(layouts: layouts, error: error, createIfEmpty: false)
            }
        } else {
            if let msg = error?.localizedDescription {
                print(msg)
            }
        }
    }
    
    private func getProfile(by layoutId: String, completion: @escaping () -> ()) {
        api.getUserProfile(by: layoutId) { [weak self] (profile, error) in
            guard let `self` = self else {
                return
            }
            
            self.profile = profile
            completion()
        }
    }
    
    private func prepareUI(){
        self.initializeApplePay()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        self.profileImageView.layer.masksToBounds = true
        
        self.amountTextField.shouldReturn = {
            self.commentTextField.becomeFirstResponder()
            return false
        }
        self.commentTextField.shouldReturn = {
            self.commentTextField.resignFirstResponder()
            return false
        }
        
        self.amountTextField.didChange = {
            self.amountsCollectionView.indexPathsForSelectedItems?.forEach {
                self.amountsCollectionView.deselectItem(at: $0, animated: true)
            }
            
            self.amountsCollectionView.reloadData()
        }
        
        self.amountsCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        
        let attributes1: [NSAttributedString.Key : Any] =
            [.foregroundColor : UIColor.mainText,
             .font: UIFont.systemFont(ofSize: 11)]
        let attributedTitle1 = NSMutableAttributedString.init(string: "Совершая платеж, вы соглашаетесь с ", attributes: attributes1)
        
        let attributes2: [NSAttributedString.Key : Any] =
            [.foregroundColor : UIColor.waterBlue,
             .font: UIFont.systemFont(ofSize: 11)]
        let attributedTitle2 = NSMutableAttributedString.init(string: "условиями сервиса", attributes: attributes2)
        
        attributedTitle1.append(attributedTitle2)
        self.eulaButton.setAttributedTitle(attributedTitle1, for: .normal)
        
        self.eulaButton.onAction = {
            if let url = URL.init(string: "https://static.cloudpayments.ru/docs/cloudtips_oferta.pdf"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        self.payButton.onAction = {
            self.performSegue(withIdentifier: .tipsToCardSegue, sender: self)
        }
    }
    
    private func updateUI() {
        self.nameLabel.text = self.profile?.name
        self.purposeLabel.text = self.profile?.name
        
        if let photoUrl = self.profile?.photoUrl, let url = URL.init(string: photoUrl) {
            self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage.named("ic_avatar_placeholder"), options: .avoidAutoSetImage, completed: { (image, error, cacheType, url) in
                if cacheType == .none && image != nil {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.profileImageView.alpha = 0
                    }, completion: { (status) in
                        self.profileImageView.image = image
                        UIView.animate(withDuration: 0.2, animations: {
                            self.profileImageView.alpha = 1
                        })
                    })
                } else {
                    self.profileImageView.image = image ?? UIImage.named("ic_avatar_placeholder")
                    self.profileImageView.alpha = 1
                }
            })
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.defaultAmounts.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultAmountCell", for: indexPath) as! DefaultAmountCell
        let amount = self.defaultAmounts[indexPath.item]
        cell.titleLabel.text = NumberFormatter.currencyString(from: NSNumber(value: amount), withDigits: 0)
        cell.setSelected(cell.isSelected)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DefaultAmountCell {
            let amount = self.defaultAmounts[indexPath.item]
            self.amountTextField.text = String(amount)
            cell.setSelected(true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DefaultAmountCell {
            cell.setSelected(false)
        }
    }
}

extension TipsViewController: PKPaymentAuthorizationControllerDelegate {
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        
    }
    
    
}
