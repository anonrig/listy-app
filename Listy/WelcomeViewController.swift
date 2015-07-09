//
//  WelcomeControllerViewController.swift
//  Listy
//
//  Created by Baris Can Vural on 7/9/15.
//  Copyright (c) 2015 Baris Can Vural. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var ProfileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.height/2;
        self.ProfileImage.layer.masksToBounds = true;
        self.ProfileImage.layer.borderWidth = 0.1;
        
        self.ProfileImage.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).CGColor;
        self.ProfileImage.layer.borderWidth = 4.0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
