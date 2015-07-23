
import UIKit
import Pages

class CarouselViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var imageName: String?
    var bottomText: String?
    var pages: PagesController?
    var pageIndex: Int?
    var getStartedTriggered = false
    
    enum SwipeAnimationType {
        case  GetStarted
        case  Restore
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: self.imageName!)
        self.label.text = self.bottomText
        self.getStartedBtn.hidden = true //
        
        var backgroundView = UIImageView(image: UIImage(named: "background.png"))
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        setupView() //pager index
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func swipeleft(){
        if(self.pageIndex == (self.pages?.pagesCount)! - 1 && !self.getStartedTriggered){//if it's the rightmost view
            performAnimations(SwipeAnimationType.GetStarted)
            self.getStartedTriggered = true
            return
        }
        pages?.goTo(self.pageController.currentPage+1)
    }
    
    func swiperight(){
        if(self.getStartedTriggered){
            performAnimations(SwipeAnimationType.Restore)
            self.getStartedTriggered = false
            return
        }
        pages?.goTo(self.pageController.currentPage-1)
    }
    
    func performAnimations(animationType: SwipeAnimationType){
        
        switch(animationType){
        case .GetStarted:
            
            //label and pager moves down and fades out
            
            UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.label.frame = self.getRec(self.label.frame, moveX: 0, moveY: 100)
                self.label.alpha = 0
                self.pageController.alpha = 0
                self.pageController.frame = self.getRec(self.pageController.frame, moveX: 0, moveY: 100)
                }, completion: nil)
            
            //button fade in
            self.getStartedBtn.alpha = 0
            self.getStartedBtn.hidden = false
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.getStartedBtn.alpha = 1
                }, completion: nil)
            
        case .Restore:
            
            //button fade in
            self.getStartedBtn.alpha = 0
            self.getStartedBtn.hidden = true
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.getStartedBtn.alpha = 1
                }, completion: nil)
            
            //label and pager moves up and fades in
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.pageController.alpha = 1
                self.label.alpha = 1
                self.pageController.frame = self.getRec(self.pageController.frame, moveX: 0, moveY: -100)
                self.label.frame = self.getRec(self.label.frame, moveX: 0, moveY: -100)
                }, completion:nil)
        }
    }
    
    //given a frame, returns a CGRect with its origin point moved
    //moveX: the amount moved in xcoordinate
    func getRec(frame: CGRect, moveX: CGFloat, moveY: CGFloat) -> CGRect{
        return CGRectMake(frame.origin.x + moveX, frame.origin.y + moveY, frame.width, frame.height)
    }
    
    func setupView(){
        if(self.pageIndex == 0){ //if it's the leftmost view, only add left swipe
            pageController.currentPage = 0
            addLeftGestureRecognizer()
        } else {
            
            //add an event listener to button only if it's the last view in carousel
            if(self.pageIndex == (self.pages?.pagesCount)! - 1 ){
                self.getStartedBtn.addTarget(self, action: "getStartedPressed", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            pageController.currentPage = self.pageIndex!
            addLeftGestureRecognizer()
            addRightGestureRecognizer()
        }
    }
    
    func addLeftGestureRecognizer(){
        var gr: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeleft")
        gr.direction = UISwipeGestureRecognizerDirection.Left
        gr.delegate = self
        self.view.addGestureRecognizer(gr)
    }
    func addRightGestureRecognizer(){
        var gr: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swiperight")
        gr.direction = UISwipeGestureRecognizerDirection.Right
        gr.delegate = self
        self.view.addGestureRecognizer(gr)
    }
    
    func backPressed(){
        //animate to login view only if it's the first view. Otherwise, go to previous view in carousel
        if(self.pageIndex == 0){
            var transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.addAnimation(transition, forKey: nil)
            self.dismissViewControllerAnimated(false, completion: nil)
        } else {
            self.pages?.previous()
            //Trigger Restore animation if get started button was presented before
            if(self.getStartedTriggered){
                performAnimations(SwipeAnimationType.Restore)
                self.getStartedTriggered = false
            }
        }
    }
    
    func getStartedPressed(){
        var transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage{
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        var thumbnailRect = CGRectMake(0, 0, 0, 0)
        thumbnailRect.origin = CGPointMake(0, 0)
        thumbnailRect.size.width = width
        thumbnailRect.size.height = height
        image.drawInRect(thumbnailRect)
        var tempImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tempImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let backBtn = UIBarButtonItem(image: self.resizeImage(UIImage(named: "black_arrow")!, width: 30, height: 30), style: UIBarButtonItemStyle.Plain, target: self, action: "backPressed")
        self.navItem.leftBarButtonItem = backBtn
    }
}
