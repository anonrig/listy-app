

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var pageIndex: Int!
    var labelText: String!
    var imageFile: String!
    var isLastView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage(named: self.imageFile)
        self.label.text = self.labelText
        self.button.hidden = true
        self.view.backgroundColor = UIColor.clearColor()
        
        if(self.isLastView){
        //add left swipe gesture
        var gr = UISwipeGestureRecognizer(target: self, action: "swipeleft")
        gr.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(gr)
        }
        
    }
    
    func swipeleft(){
        println("swipeleft")
    }
    
    @IBAction func getStartedPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
