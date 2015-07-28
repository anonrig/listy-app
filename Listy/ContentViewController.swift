
import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var pageIndex: Int!
    var labelText: String!
    var imageFile: String!
    var isLastView = false
    var pager: UIPageControl!
    var getStartedTriggered = false
    var pageViewController: UIPageViewController! //for re-enabling carousel's disabled scrolling
    
    enum SwipeAnimationType {
        case GetStarted
        case Restore
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: self.imageFile)
        self.label.text = self.labelText
        self.button.hidden = true
        self.view.backgroundColor = UIColor.clearColor()
        
        if(self.isLastView){
            //add left swipe gesture
            var grLeft = UISwipeGestureRecognizer(target: self, action: "swipeleft")
            grLeft.direction = UISwipeGestureRecognizerDirection.Left
            self.view.addGestureRecognizer(grLeft)
            //add right swipe gesture
            var grRight = UISwipeGestureRecognizer(target: self, action: "swiperight")
            grRight.direction = UISwipeGestureRecognizerDirection.Right
            self.view.addGestureRecognizer(grRight)
            
            self.button.alpha = 0
            self.button.hidden = false
        }
        
    }
    
    func swiperight(){
        if(self.getStartedTriggered == true){
            self.performAnimations(.Restore)
            self.getStartedTriggered = false
            //restore Carousel's scrolling
            //it was disabled before transitioning to this view
            for obj in self.pageViewController.view.subviews{
                if(obj.isKindOfClass(UIScrollView)){
                    var scrollView = obj as! UIScrollView
                    scrollView.scrollEnabled = true
                }
            }
        }
    }
    
    func swipeleft(){
        if(self.getStartedTriggered == false){
            self.performAnimations(.GetStarted)
            self.getStartedTriggered = true
        }
    }
    
    func performAnimations(animationType: SwipeAnimationType){
        
        switch(animationType){
        case .GetStarted:
            
            //label and pager moves down and fades out
            
            UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                
                self.label.frame = self.getRec(self.label.frame, moveX: 0, moveY: 100)
                self.label.alpha = 0
                self.pager.alpha = 0
                self.pager.frame = self.getRec(self.pager.frame, moveX: 0, moveY: 100)
                }, completion: nil)
            
            //button fade in
            self.button.alpha = 0
            self.button.hidden = false
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.button.alpha = 1
                }, completion: nil)
            
        case .Restore:
            
            //button fade in
            self.button.alpha = 0
            self.button.hidden = true
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.button.alpha = 1
                }, completion: nil)
            
            //label and pager moves up and fades in
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.pager.alpha = 1
                self.label.alpha = 1
                self.pager.frame = self.getRec(self.pager.frame, moveX: 0, moveY: -100)
                self.label.frame = self.getRec(self.label.frame, moveX: 0, moveY: -100)
                }, completion:nil)
        }
    }
    
    //given a frame, returns a CGRect with its origin point moved
    //moveX: the amount moved in xcoordinate
    func getRec(frame: CGRect, moveX: CGFloat, moveY: CGFloat) -> CGRect{
        return CGRectMake(frame.origin.x + moveX, frame.origin.y + moveY, frame.width, frame.height)
    }
    
    @IBAction func getStartedPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
