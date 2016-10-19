//
//  ContentViewController.swift
//  iEnglish
//
//  Created by Dareen Hsu on 1/4/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        return boundingBox.height
    }
}

class ContentViewController: UIViewController, UIScrollViewDelegate {

    var currentIndex : NSInteger?
    let manager : IEManager = IEManager.sharedInstance

    @IBOutlet weak var baseScrollView : UIScrollView?
    @IBOutlet weak var baseView : UIView?
    @IBOutlet weak var wordLabel : UILabel?
    @IBOutlet weak var chinessLabel : UILabel?
    @IBOutlet weak var sentenceLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.currentIndex = currentIndex!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setDefaultData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDefaultData() {
        var contentHeight:CGFloat = 0
        let entity : WordEntity = manager.words?.object(at: currentIndex!) as! WordEntity
        wordLabel?.text = entity.word

        let wHeight = entity.word?.heightWithConstrainedWidth((wordLabel?.frame.size.width)!, font: (wordLabel?.font)!)
        wordLabel?.frame = CGRect(x: (wordLabel?.frame.origin.x)!, y: (wordLabel?.frame.origin.y)!, width: (wordLabel?.frame.size.width)!, height: wHeight!)
        contentHeight += wHeight!

        chinessLabel?.text = entity.chiness
        let cHeight = entity.chiness?.heightWithConstrainedWidth((chinessLabel?.frame.size.width)!, font: (chinessLabel?.font)!)
        chinessLabel?.frame = CGRect(x: (chinessLabel?.frame.origin.x)!, y: (wordLabel?.frame.origin.y)! + (wordLabel?.frame.size.height)! + 10, width: (chinessLabel?.frame.size.width)!, height: cHeight!)
        contentHeight += cHeight! + 10

        let sEntity : SentenceEntity? = SentenceEntity.getSentence(entity)
        sentenceLabel?.text = sEntity?.sentence
        let sHeight = sEntity?.sentence?.heightWithConstrainedWidth((sentenceLabel?.frame.size.width)!, font: (sentenceLabel?.font)!)
        sentenceLabel?.frame = CGRect(x: (sentenceLabel?.frame.origin.x)!, y: (chinessLabel?.frame.origin.y)! + (chinessLabel?.frame.size.height)! + 10, width: (sentenceLabel?.frame.size.width)!, height: sHeight!)
        contentHeight += sHeight! + 10

        baseView?.frame = CGRect(x: 0, y: 0, width: (baseScrollView?.frame.size.width)!, height: contentHeight)
        baseScrollView?.contentSize = CGSize(width: (baseScrollView?.frame.size.width)!, height: contentHeight)
    }

    func zoomScaleThatFits(target: CGSize, source: CGSize ) -> CGFloat {
        let w_scale : CGFloat = (target.width / source.width)
        let h_scale : CGFloat = (target.height / source.height)

        return ((w_scale < h_scale) ? w_scale : h_scale)
    }

    // MARK: - UIScrollViewDelegate Methods
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return baseView
    }
}
