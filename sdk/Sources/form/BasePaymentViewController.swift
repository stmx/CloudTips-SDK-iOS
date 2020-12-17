//
//  BasePaymentViewController.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 07.10.2020.
//

import Foundation
import WebKit

public class BasePaymentViewController: BaseViewController, PaymentDelegate {
    internal var configuration: TipsConfiguration!
    internal var paymentData: PaymentData?
    internal var paymentError: CloudtipsError?
    
    @IBOutlet weak var captchaWebViewContainer: UIView?
    var captchaWebView: WKWebView?
    var recaptchaViewModel: RecaptchaViewModel = RecaptchaViewModel()
    
    internal func onPaymentSucceeded() {
        self.paymentError = nil
        self.performSegue(withIdentifier: .toResultSegue, sender: self)
    }
    
    internal func onPaymentFailed(with error: CloudtipsError?){
        self.paymentError = error
        self.performSegue(withIdentifier: .toResultSegue, sender: self)
    }
    
    func askForV3Captcha(with layoutId: String, amount: String, completion: ((_ token: String?, _ shoudAskForV2: Bool) -> ())?){
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        self.recaptchaViewModel = RecaptchaViewModel()
        self.recaptchaViewModel.onCaptchaVerified = { token in
            if let token = token {
                self.verifyCaptcha(version: 3, token: token, amount: amount, layoutId: layoutId) { (response, error) in
                    if response?.status?.lowercased() == "passed" {
                        completion?(response!.token, false)
                    } else if response?.status?.lowercased() == "shouldverifyv2" {
                        completion?(nil, true)
                    }
                }
            } else {
                completion?(nil, false)
            }
        }
        self.recaptchaViewModel.start()
        
        let contentController = WKUserContentController()
        contentController.add(self.recaptchaViewModel, name: self.recaptchaViewModel.handlerName)
        
        configuration.userContentController = contentController
        
        self.captchaWebView = WKWebView.init(frame: self.captchaWebViewContainer?.bounds ?? .zero, configuration: configuration)
        self.captchaWebViewContainer?.addSubview(self.captchaWebView!)
        self.captchaWebViewContainer?.bindFrameToSuperviewBounds()
        self.captchaWebView!.loadHTMLString(self.recaptchaViewModel.html, baseURL: URL.init(string: HTTPResource.baseURLString))
    }
    
    //MARK: - Prepare for segue -
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case .toResultSegue:
                if let controller = segue.destination as? CompletionViewController {
                    controller.paymentError = self.paymentError
                    controller.configuration = self.configuration
                }
            default:
                super.prepare(for: segue, sender: sender)
                break
            }
        }
    }
}
