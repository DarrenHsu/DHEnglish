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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Word Book"

        manager.getCurrentWords()
        manager.currentIndex = 0

        let c : ContentViewController? = getContentController(0)

        if (c == nil) {
            return
        }

        pageController = UIPageViewController.init();
        pageController?.dataSource = self
        pageController?.view.frame = pageView!.bounds
        pageController?.setViewControllers([c!], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)

        self.addChildViewController(pageController!)
        pageView!.addSubview((pageController?.view)!)

        pageController?.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return getContentController(manager.currentIndex! - 1)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return getContentController(manager.currentIndex! + 1)
    }
}