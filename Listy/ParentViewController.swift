
import UIKit

class ParentViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    var pageLabels: NSArray!
    var pageImages: NSArray!
    
    @IBOutlet weak var pager: UIPageControl!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationItem.title = "Carousel"
        if (self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") != nil) {
            self.navigationController?.interactivePopGestureRecognizer.enabled = false
        }
        self.pageLabels = NSArray(objects: "Create a list that you want to share it\nwith your family and friends.", "Swipe left to see actions,\nfull swipe to mark as done.", "Let others know\nwhat you completed in an instant.")
        self.pageImages = NSArray(objects: "tutorial1", "tour2", "tutorial3")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        var startVC = self.viewControllerAtIndex(0) as ContentViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height-80)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.view.bringSubviewToFront(self.pager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        if((self.pageLabels.count==0 || index >= self.pageLabels.count)){
            return ContentViewController()
        }
        
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        vc.imageFile = self.pageImages[index] as! String
        vc.labelText = self.pageLabels[index] as! String
        vc.pageIndex = index
        vc.pager = self.pager
        
        if(index == self.pageLabels.count-1){
            vc.isLastView = true
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
    
    //turn off carousel on last page
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        //Did we just transition to last view?
        if((pageViewController.viewControllers.first as! ContentViewController).pageIndex == self.pageLabels.count-1){
            //disable scroolview in UIPageViewControlelr
            for obj in pageViewController.view.subviews{
                if(obj.isKindOfClass(UIScrollView)){
                    var scrollView = obj as! UIScrollView
                    scrollView.scrollEnabled = false
                }
            }
        }
    }
    
}
