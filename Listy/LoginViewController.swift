
import UIKit

class LoginViewController: UIViewController {
    @IBAction func connectPressed(sender: AnyObject) {
        self.login()
    }
    
    let httpHelper = HTTPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    func login(){
        var login : FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["email"], handler: { (result : FBSDKLoginManagerLoginResult!, error :NSError!) -> Void in
            if ((error) != nil || result.isCancelled) {
                // Process error
                
                let alertController = UIAlertController(title: "Sorry", message:
                    "Failed to connect to Facebook servers", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                login.logOut();
                
                println("error");
            } else {
                // If you ask for multiple permissions at once, you should check if specific permissions missing
                if (result.grantedPermissions.contains("email")){
                    self.sendFBTokens(result.token.tokenString);
                }
            }
        })
    }
    
    func sendFBTokens(access_token:String){
        let httpRequest = httpHelper.buildRequest("accounts/facebook", method: "POST",
            authType: HTTPRequestAuthType.FBTokenAuth)
        
        httpRequest.HTTPBody = "{\"access_token\":\"\(access_token)\"}".dataUsingEncoding(NSUTF8StringEncoding);
        
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                println(errorMessage);
                //TODO LOGout
                return
            }
            
            self.navigationController?.performSegueWithIdentifier("LoginToWelcome", sender: self)
            
            var token:String = JSON(data:data)["token"].stringValue
            KeychainAccess.setPassword(token, account: "jwt-token", service: "KeyChainService")
            
            
            
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
