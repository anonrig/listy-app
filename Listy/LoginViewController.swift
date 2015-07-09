//
//  ViewController.swift
//  Shop
//
//  Created by Baris Can Vural on 7/9/15.
//  Copyright (c) 2015 Baris Can Vural. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBAction func connectPressed(sender: AnyObject) {
        self.navigationController?.performSegueWithIdentifier("LoginToWelcome", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

