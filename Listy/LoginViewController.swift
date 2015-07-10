
import UIKit

class LoginViewController: UIViewController {
    @IBAction func connectPressed(sender: AnyObject) {
        self.login()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            // User is logged in, do work such as go to next view controller.
            self.navigationController?.performSegueWithIdentifier("LoginToWelcome", sender: self)
        }
    }
    func login(){
        var login : FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["email"], handler: { (result : FBSDKLoginManagerLoginResult!, error :NSError!) -> Void in
            if ((error) != nil) {
                // Process error
                println("error")
            } else if (result.isCancelled) {
                // Handle cancellations
                println("Cancelled")
            } else {
                // If you ask for multiple permissions at once, you should check if specific permissions missing
                if (result.grantedPermissions.contains("email")){
                    self.navigationController?.performSegueWithIdentifier("LoginToWelcome", sender: self)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
