
import UIKit
import Presentation
import FBSDKLoginKit
import AVFoundation

class LoginViewController: UIViewController {
    @IBAction func connectPressed(sender: AnyObject) {
        self.login()
    }
    
    let httpHelper = HTTPHelper()
    var loginManager : FBSDKLoginManager = FBSDKLoginManager()
    var avplayer: AVPlayer?
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBarHidden = true;
        
        var error:NSError?
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: &error)
        AVAudioSession.sharedInstance().setActive(true, error: &error)
        //set up player
        var movieURL : NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("listy", ofType: "mp4")!)
        var avAsset: AVAsset = AVAsset.assetWithURL(movieURL) as! AVAsset
        var avPlayerItem = AVPlayerItem(asset: avAsset)
        self.avplayer = AVPlayer(playerItem: avPlayerItem)
        
        var avPlayerLayer = AVPlayerLayer(player: self.avplayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayerLayer.frame = UIScreen.mainScreen().bounds
        
        var movieView = UIView(frame: self.view.frame)
        movieView.layer.addSublayer(avPlayerLayer)
        self.view.addSubview(movieView)
        
        //Config player
        
        self.avplayer?.seekToTime(kCMTimeZero)
        self.avplayer?.volume = 0
        self.avplayer?.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerStartPlaying", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerFinishedPlaying", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
        var gradient = CAGradientLayer()
        gradient.frame = UIScreen.mainScreen().bounds
        
        var color1 = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 0.5)
        var color2 = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
        
        gradient.colors = [color1, color2, color1]
        var gradientView = UIView(frame: self.view.frame)
        gradientView.backgroundColor = color1
        
        self.view.addSubview(gradientView)
        self.view.sendSubviewToBack(gradientView)
        self.view.sendSubviewToBack(movieView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.avplayer?.pause()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.avplayer?.play()
    }
    
    func playerStartPlaying(){
        self.avplayer?.play()
    }
    
    func playerFinishedPlaying(){
        self.avplayer?.seekToTime(kCMTimeZero)
    }
    
    func login(){
        loginManager.logInWithReadPermissions(["email"], handler: { (result : FBSDKLoginManagerLoginResult!, error :NSError!) -> Void in
            if ((error) != nil || result.isCancelled) {
                // Process error
                
                let alertController = UIAlertController(title: "Sorry", message:
                    "Failed to connect to Facebook servers", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                if (!result.isCancelled) {
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                self.loginManager.logOut();
                
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
                
                let alertController = UIAlertController(title: "Sorry", message:
                    "Failed to connect to Listy servers", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                self.loginManager.logOut();
                
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
