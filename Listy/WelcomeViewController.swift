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
    @IBOutlet weak var frontNum: UILabel! //number of people in front of the user
    @IBOutlet weak var behindNum: UILabel! //number of people behind the user
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var staticTextTop: UILabel!  // "People in front of you"
    @IBOutlet weak var staticTextBottom: UILabel! //"People behind you"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideUserInfo(true)
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        println(FBSDKAccessToken.currentAccessToken())
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.height/2;
        self.ProfileImage.layer.masksToBounds = true;
        self.ProfileImage.layer.borderWidth = 0.1;
        
        self.ProfileImage.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).CGColor;
        self.ProfileImage.layer.borderWidth = 4.0;
    }
    
    //toggle display of user info before and after we pull data from FB
    func hideUserInfo(shouldHide:Bool){
        self.ProfileImage.hidden = shouldHide
        self.frontNum.hidden = shouldHide
        self.behindNum.hidden = shouldHide
        self.staticTextTop.hidden = shouldHide
        self.staticTextBottom.hidden = shouldHide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
