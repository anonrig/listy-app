
import UIKit
import Social // for facebook share

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var frontNum: UILabel! //number of people in front of the user
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var staticTextTop: UILabel!  // "People in front of you"
    
    @IBOutlet weak var staticTextBottom: UILabel!
    let httpHelper = HTTPHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideUserInfo(true)
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        println(FBSDKAccessToken.currentAccessToken())
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        
        self.getProfileInfo();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let shareButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareAction")
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    func shareAction(){
        
        println("Share")
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let fbShareAction = UIAlertAction(title: "Share on Facebook", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Share on FB")
            // Open Facebook App if there is one
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                self.presentViewController(fbShare, animated: true, completion: nil)
                
            } else {
                var content : FBSDKShareLinkContent = FBSDKShareLinkContent()
                content.contentURL = NSURL(string: "http://www.youtube.com")
                content.contentDescription = "I'm the number \((self.frontNum.text?.toInt()!)! + 1) on the list!"
                content.contentTitle = "Listy"
                FBSDKShareDialog.showFromViewController(self, withContent:content, delegate: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        optionMenu.addAction(fbShareAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func getProfileInfo() {
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest("accounts/me", method: "GET",
            authType: HTTPRequestAuthType.HTTPTokenAuth)
        
        httpRequest.HTTPBody = "".dataUsingEncoding(NSUTF8StringEncoding);
        
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                
                println("error getting user information");
                
                let alertController = UIAlertController(title: "Sorry", message:
                    "Failed to connect to Listy servers", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: {(action)->Void in
                    self.goToLoginView()
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)

                return
            }
            var jsonData : JSON = JSON(data:data)
            println(jsonData)
            
            self.updateProfileImage(jsonData["facebook"]["photo"].stringValue+"&width=400&height=400")
            self.frontNum.text = jsonData["line"].stringValue
            
            self.hideUserInfo(false);
            self.activityIndicator.hidden = true
        })
    }
    
    //segue from left
    func goToLoginView(){
        
        var mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let source : UIViewController = self
        let destination : LoginViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        
        var transition : CATransition = CATransition()
        transition.duration = 0.25;
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut);
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        source.navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
        
        source.navigationController?.pushViewController(destination, animated: false)
    }
    
    func updateProfileImage(url:String){
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.ProfileImage.image = UIImage(data: data!)
        //round corners, style the image
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
        self.staticTextTop.hidden = shouldHide
        self.staticTextBottom.hidden = shouldHide
        self.navigationItem.rightBarButtonItem?.enabled = !shouldHide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
