

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
        println("swipeleft")
        if(pages?.currentIndex==2){
            performAnimations(SwipeAnimationType.GetStarted)
            self.getStartedTriggered = true
            return
        }
        pages?.goTo(self.pageController.currentPage+1)
    }
    
    func swiperight(){
        println("swiperight")
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
            UIView.animateWithDuration(2, animations: { () -> Void in
            
            self.label.frame = self.getRec(self.label.frame, moveX: 0, moveY: 100)
            self.label.hidden = true
            self.pageController.hidden = true
            self.pageController.frame = self.getRec(self.pageController.frame, moveX: 0, moveY: 100)
            })
            
            //button fade in
            self.getStartedBtn.alpha = 0
            self.getStartedBtn.hidden = false
            
            UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.getStartedBtn.alpha = 1
            }, completion: nil)
            
        case .Restore:
            //label and pager moves up and fades in
            UIView.animateWithDuration(2, animations: { () -> Void in
                
                self.pageController.hidden = false
                self.pageController.frame = self.getRec(self.pageController.frame, moveX: 0, moveY: -100)
                self.label.frame = self.getRec(self.label.frame, moveX: 0, moveY: -100)
                self.label.hidden = false
                
            })
            
            //button fade in
            self.getStartedBtn.alpha = 0
            self.getStartedBtn.hidden = true
            
            UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.getStartedBtn.alpha = 1
                }, completion: nil)
        }
        
    }
    
    //given a frame, returns a CGRect with its origin point moved
    //moveX: the amount moved in xcoordinate
    func getRec(frame: CGRect, moveX: CGFloat, moveY: CGFloat) -> CGRect{
        return CGRectMake(frame.origin.x + moveX, frame.origin.y + moveY, frame.width, frame.height)
    }
    
    //hardcoding page indices
    func setupView(){
        if(self.imageName == "tour1"){
            pageController.currentPage = 0
            addLeftGestureRecognizer()
        } else if(self.imageName == "tour2"){
            pageController.currentPage = 1
            addLeftGestureRecognizer()
            addRightGestureRecognizer()
        } else if(self.imageName == "tour3"){
            pageController.currentPage = 2
            addRightGestureRecognizer()
            addLeftGestureRecognizer()
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
