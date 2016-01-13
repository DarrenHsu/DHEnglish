//
//  PageViewController.swift
//  iEnglish
//
//  Created by Dareen Hsu on 12/21/15.
//  Copyright © 2015 D.H. All rights reserved.
//

import UIKit

class PageViewController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak var pageView : UIView?

    var pageController : UIPageViewController?
    let manager : IEManager = IEManager.sharedInstance

    @IBAction func editPressed(sender : UIBarButtonItem) {
        let alertController = UIAlertController(title: "Hello", message: "What do you want to do?", preferredStyle: .ActionSheet)

        if (self.manager.count > 0) {
            let updateAction = UIAlertAction(title: "Update", style: .Default, handler: {(action : UIAlertAction) -> Void in

            })
            alertController.addAction(updateAction)
        }

        if (self.manager.count > 0) {
            let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {(action : UIAlertAction) -> Void in
                let entity : WordEntity = self.manager.words?.objectAtIndex(self.manager.currentIndex) as! WordEntity
                entity.delete()

                self.manager.getCurrentWords()
                self.manager.currentIndex = self.manager.currentIndex != 0 ? self.manager.currentIndex - 1 : 0

                self.goToCurrentPage(false)
            })

            alertController.addAction(deleteAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Word Book"

        manager.getCurrentWords()

        goToCurrentPage(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goToCurrentPage(animated : Bool) {
        pageController?.view.removeFromSuperview()
        pageController?.removeFromParentViewController()

        pageController = UIPageViewController.init();
        pageController?.dataSource = self
        pageController?.view.frame = pageView!.bounds

        self.addChildViewController(pageController!)
        pageView!.addSubview((pageController?.view)!)
        pageController?.didMoveToParentViewController(self)

        let c : ContentViewController? = getContentController(manager.currentIndex)

        if (c != nil) {
            pageController?.setViewControllers([c!], direction: UIPageViewControllerNavigationDirection.Reverse, animated: animated, completion: nil)
        }
    }

    func getContentController(pageIndex : NSInteger) -> ContentViewController? {
        print("page index \(pageIndex)")
        if (0 <= pageIndex && pageIndex < manager.count) {
            let controller : ContentViewController? = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewController") as? ContentViewController
            controller?.currentIndex = pageIndex
            return controller;
        } else {
            return nil
        }
    }

    // MARK: - UIPageViewControllerDataSsource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return getContentController(manager.currentIndex - 1)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return getContentController(manager.currentIndex + 1)
    }
}