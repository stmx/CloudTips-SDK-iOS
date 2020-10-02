//
//  DefaultAmountCell.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 01.10.2020.
//

import Foundation
import UIKit

class DefaultAmountCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgView.layer.cornerRadius = 4.0
        self.bgView.layer.masksToBounds = true
        
        self.titleLabel.layer.cornerRadius = 4.0
        self.titleLabel.layer.masksToBounds = true
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            self.contentView.layer.shadowColor = UIColor.clear.cgColor
            self.contentView.layer.shadowRadius = 4.0
            
            self.bgView.backgroundColor = .azure
        } else {
            self.contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
            self.contentView.layer.shadowRadius = 4.0
            self.contentView.layer.shadowOffset = .zero
            self.contentView.layer.shadowOpacity = 0.5
            self.contentView.layer.shadowPath = UIBezierPath(rect: self.contentView.bounds).cgPath
            self.contentView.layer.masksToBounds = false
            
            self.bgView.backgroundColor = .white
        }
    }
}
