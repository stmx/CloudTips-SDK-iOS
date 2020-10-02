//
//  CompletionViewController.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 29.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import UIKit

class CompletionViewController: BaseViewController {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var statusIcon: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var repeatButton: Button!
    
    var profile: Profile?
    var error: CloudtipsError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
        self.updateUI()
    }
    
    private func prepareUI(){
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        self.profileImageView.layer.masksToBounds = true
        
        self.repeatButton.onAction = {
            self.performSegue(withIdentifier: .unwindToTipsSegue, sender: self)
        }
    }
    
    private func updateUI() {
        self.nameLabel.text = self.profile?.name
        
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
        
        if let error = self.error {
            self.statusIcon.image = .iconFailed
            
            self.errorTitleLabel.isHidden = false
            self.messageLabel.text = error.message
            self.messageLabel.textColor = .mainRed
            
            self.repeatButton.setTitle("Попробовать ещё раз", for: .normal)
        } else {
            self.statusIcon.image = .iconSuccess
            
            self.errorTitleLabel.isHidden = true
            self.messageLabel.text = self.profile?.successPageText ?? "Радуется вашим чаевым!"
            self.messageLabel.textColor = .sectionTitleColor
            
            self.repeatButton.setTitle("Отправить ещё", for: .normal)
        }
    }
}
