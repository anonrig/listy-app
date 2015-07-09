//
//  WelcomeControllerViewController.swift
//  Listy
//
//  Created by Baris Can Vural on 7/9/15.
//  Copyright (c) 2015 Baris Can Vural. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
