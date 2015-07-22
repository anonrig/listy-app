

import UIKit

class CarouselViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    var imageName: String?
    var bottomText: String?
    var gr: UIGestureRecognizer?
    
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
    }
    
    func swiperight(){
        println("swiperight")
    }
    
    //hardcoding page indices
    func setupView(){
        if(self.imageName == "tour1"){
            pageController.currentPage = 0
            var gr: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeleft")
            gr.direction = UISwipeGestureRecognizerDirection.Right
            gr.delegate = self
            self.view.addGestureRecognizer(gr)
        } else if(self.imageName == "tour2"){
            pageController.currentPage = 1
        } else if(self.imageName == "tour3"){
            pageController.currentPage = 2
            var gr: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swiperight")
            gr.direction = UISwipeGestureRecognizerDirection.Left
            gr.delegate = self
            self.view.addGestureRecognizer(gr)
        }
    }
}
