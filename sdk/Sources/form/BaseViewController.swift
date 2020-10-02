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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addLogoToNavigationBarItem()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
    }
    
    @objc private func pop(){
        self.navigationController?.popViewController(animated: true)
    }
}
