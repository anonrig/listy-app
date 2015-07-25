
import UIKit

class ParentViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    var pageLabels: NSArray!
    var pageImages: NSArray!
    
    @IBOutlet weak var pager: UIPageControl!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationItem.title = "Carousel"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageLabels = NSArray(objects: "This is view1", "This is view2", "This is view3")
        self.pageImages = NSArray(objects: "tour1", "tour2", "tour3")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        var startVC = self.viewControllerAtIndex(0) as ContentViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
      
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.size.height)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
            self.view.bringSubviewToFront(self.pager)
        
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        if((self.pageLabels.count==0 || index >= self.pageLabels.count)){
            return ContentViewController()
        }
        
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        vc.imageFile = self.pageImages[index] as! String
        vc.labelText = self.pageLabels[index] as! String
        vc.pageIndex = index
        
        if(index == self.pageLabels.count-1){
            vc.buttonHidden = false
        }
        
        return vc
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound){
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == NSNotFound){
            return nil
        }
        
        index++
        
        if(index == self.pageLabels.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    // MARK: - Page View Controller Delegate method
    
    //update pager dot
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        self.pager.currentPage = (pendingViewControllers.first as! ContentViewController).pageIndex
    }

}
