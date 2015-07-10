
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
    }
    
    func sendFBTokens(access_token:String, refresh_token:String){
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest("SOME_API_URL", method: "POST",
            authType: HTTPRequestAuthType.HTTPTokenAuth)
        
        httpRequest.HTTPBody = "{\"access_token\":\"\(access_token)\",\"refresh_token\":\"\(refresh_token)\"}".dataUsingEncoding(NSUTF8StringEncoding);
        
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                return
            }
            var jsonerror:NSError?
            let responseDict = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments, error:&jsonerror) as! NSDictionary
            var stopBool : Bool
            
            println(data)
        })
    }
    
    func getProfileInfo() {
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest("SOME_API_URL", method: "GET",
            authType: HTTPRequestAuthType.HTTPTokenAuth)
        
        httpRequest.HTTPBody = "".dataUsingEncoding(NSUTF8StringEncoding);
        
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                return
            }
            println(data)
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
