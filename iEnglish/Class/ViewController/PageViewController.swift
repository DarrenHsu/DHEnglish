//
//  PageViewController.swift
//  iEnglish
//
//  Created by Dareen Hsu on 12/21/15.
//  Copyright © 2015 D.H. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class PageViewController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak var pageView: UIView?
    @IBOutlet weak var loadingView: UIView?

    var pageController : UIPageViewController?
    let manager : IEManager = IEManager.sharedInstance

    @IBAction func editPressed(_ sender : UIBarButtonItem) {
        let alertController = UIAlertController(title: "Hello", message: "What do you want to do?", preferredStyle: .actionSheet)

        if (self.manager.count > 0) {
            let updateAction = UIAlertAction(title: "Update", style: .default, handler: {(action : UIAlertAction) -> Void in
                let controller : EditViewController! = self.storyboard!.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController

                let word : WordEntity! = self.manager.words![self.manager.currentIndex] as! WordEntity
                controller.selectWord = word
                self.navigationController?.pushViewController(controller, animated: true)
            })
            alertController.addAction(updateAction)
        }

        if (self.manager.count > 0) {
            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: {(action : UIAlertAction) -> Void in
                let entity : WordEntity = self.manager.words?.object(at: self.manager.currentIndex) as! WordEntity
                entity.delete()

                self.manager.getCurrentWords()
                self.manager.currentIndex = self.manager.currentIndex != 0 ? self.manager.currentIndex - 1 : 0

                self.goToCurrentPage(false)
            })

            alertController.addAction(deleteAction)
        }


        let downloadAction = UIAlertAction(title: "Download", style: .default, handler: {(action : UIAlertAction) -> Void in
            let feed = IEFeedManager.sharedInstance

            self.view.bringSubview(toFront: self.loadingView!)
            self.loadingView?.isHidden = false

            feed.requestWord(success: {
                self.manager.getCurrentWords()
                self.manager.currentIndex = self.manager.currentIndex != 0 ? self.manager.currentIndex - 1 : 0

                self.goToCurrentPage(false)

                self.loadingView?.isHidden = true
            }, faild: {
                self.loadingView?.isHidden = true
            })
        })

        alertController.addAction(downloadAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Word Book"

        loadingView?.layer.cornerRadius = 10
        loadingView?.isHidden = true

        manager.getCurrentWords()

        goToCurrentPage(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goToCurrentPage(_ animated : Bool) {
        pageController?.view.removeFromSuperview()
        pageController?.removeFromParentViewController()

        pageController = UIPageViewController.init();
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.view.frame = pageView!.bounds

        self.addChildViewController(pageController!)
        pageView!.addSubview((pageController?.view)!)
        pageController?.didMove(toParentViewController: self)

        let c : ContentViewController? = getContentController(manager.currentIndex)

        if (c != nil) {
            pageController?.setViewControllers([c!], direction: UIPageViewControllerNavigationDirection.reverse, animated: animated, completion: nil)
        }
    }

    func getContentController(_ pageIndex : NSInteger) -> ContentViewController? {
        print("page index \(pageIndex)")
        if (0 <= pageIndex && pageIndex < manager.count) {
            let controller : ContentViewController? = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController
            controller?.currentIndex = pageIndex
            return controller;
        } else {
            return nil
        }
    }

    // MARK: - UIPageViewController DataSsource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getContentController(manager.currentIndex - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getContentController(manager.currentIndex + 1)
    }

    // MARK: - UIPageViewController Delegate 
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed != true {
            for previousViewController in previousViewControllers {
                let index : NSInteger? = (previousViewController as! ContentViewController).currentIndex
                manager.currentIndex = index!
            }
        }
    }
}
