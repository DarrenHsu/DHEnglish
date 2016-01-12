//
//  MenuViewController.swift
//  iEnglish
//
//  Created by Dareen Hsu on 12/21/15.
//  Copyright © 2015 D.H. All rights reserved.
//

import UIKit

class MenuTableViewCell : UITableViewCell {
    @IBOutlet weak var functionNameLabel : UILabel?
    @IBOutlet weak var functionImageView : UIImageView?
}

class MenuViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTableView : UITableView?

    var functionName : [String] = ["Word Book","Add Word"]
    var functionImage : [String] = ["ic_font_download","ic_add_to_photos"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource Methos
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionName.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : MenuTableViewCell = tableView.dequeueReusableCellWithIdentifier("TableCell") as! MenuTableViewCell

        cell.functionNameLabel!.text = functionName[indexPath.row]
        cell.functionImageView?.image = UIImage.init(named: functionImage[indexPath.row])
        
        return cell
    }

    // MARK: - UITableDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var controller : BaseViewController?
        switch indexPath.row {
        case 0:
            controller = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
            break
        default:
            controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddViewController") as! AddViewController
            break
        }

        SlideNavigationController.sharedInstance()!.popAllAndSwitchToViewController(controller, withSlideOutAnimation: false, andCompletion: nil);
    }

}
