
import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var frontNum: UILabel! //number of people in front of the user
    @IBOutlet weak var behindNum: UILabel! //number of people behind the user
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var staticTextTop: UILabel!  // "People in front of you"
    @IBOutlet weak var staticTextBottom: UILabel! //"People behind you"
    
    let httpHelper = HTTPHelper()
    
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
        
        self.getProfileInfo();
    }
    
    func getProfileInfo() {
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest("accounts/me", method: "GET",
            authType: HTTPRequestAuthType.FBTokenAuth)
        
        httpRequest.HTTPBody = "".dataUsingEncoding(NSUTF8StringEncoding);
        
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                
                println("error getting user information");
                
                let alertController = UIAlertController(title: "Sorry", message:
                    "Failed to connect to Listy servers", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)

                return
            }
            println(data)
            
            self.hideUserInfo(false);
            self.activityIndicator.hidden = true
        })
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
