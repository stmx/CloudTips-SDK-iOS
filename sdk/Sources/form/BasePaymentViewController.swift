//
//  BasePaymentViewController.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 07.10.2020.
//

import Foundation

public class BasePaymentViewController: BaseViewController {
    var profile: Profile?
    internal var paymentError: CloudtipsError?
    
    internal func onPaymentSucceeded() {
        self.paymentError = nil
        self.performSegue(withIdentifier: .toResultSegue, sender: self)
    }
    
    internal func onPaymentFailed(with error: CloudtipsError?){
        self.paymentError = error
        self.performSegue(withIdentifier: .toResultSegue, sender: self)
    }
    
    //MARK: - Prepare for segue -
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case .toResultSegue:
                if let controller = segue.destination as? CompletionViewController {
                    controller.error = self.paymentError
                    controller.profile = self.profile
                }
            default:
                super.prepare(for: segue, sender: sender)
                break
            }
        }
    }
}
