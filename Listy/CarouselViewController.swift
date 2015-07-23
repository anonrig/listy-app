
import UIKit
import Pages

class CarouselViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var getStartedBtn: UIButton!
    
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
        if(self.pageIndex == (self.pages?.pagesCount)! - 1){//if it's the rightmost view
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
    
    //hardcoding page indices
    func setupView(){
        if(self.pageIndex == 0){ //if it's the leftmost view, only add left swipe
            pageController.currentPage = 0
            addLeftGestureRecognizer()
        } else {
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
}
