

import UIKit

class CarouselViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    var imageName: String?
    var bottomText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: self.imageName!)
        self.label.text = self.bottomText
        
        var backgroundView = UIImageView(image: UIImage(named: "background.png"))
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        setPageIndex() //pager index
    }
    
    //hardcoding page indices
    func setPageIndex(){
        if(self.imageName == "tour1"){
            pageController.currentPage = 0
        } else if(self.imageName == "tour2"){
            pageController.currentPage = 1
        } else if(self.imageName == "tour3"){
            pageController.currentPage = 2
        }
    }
}
