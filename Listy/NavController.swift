
import UIKit
import FBSDKCoreKit

class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            // User is logged in, do work such as go to next view controller.
            //Choosing Welcome view as the starting point of the app since we are logged in.
            let controller : WelcomeViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Welcome") as! WelcomeViewController
            self.setViewControllers(NSArray(object: controller) as [AnyObject], animated: true)
        } else {
            //Login view should be presented the first since we aren't logged in yet
            let controller : LoginViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
            self.setViewControllers(NSArray(object: controller) as [AnyObject], animated: true)
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
