

import UIKit

class CarouselViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var imageName: String?
    var bottomText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: self.imageName!)
        self.label.text = self.bottomText
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
}
