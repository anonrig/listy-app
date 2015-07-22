

import UIKit
import Pages

class CarouselViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    var imageName: String?
    var bottomText: String?
    var pages: PagesController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: self.imageName!)
        self.label.text = self.bottomText
        
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
        pages?.goTo(self.pageController.currentPage+1)
    }
    
    func swiperight(){
        println("swiperight")
        pages?.goTo(self.pageController.currentPage-1)
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
