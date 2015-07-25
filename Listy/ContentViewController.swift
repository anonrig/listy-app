

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var pageIndex: Int!
    var labelText: String!
    var imageFile: String!
    var buttonHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage(named: self.imageFile)
        self.label.text = self.labelText
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.button.hidden = self.buttonHidden
    }
}