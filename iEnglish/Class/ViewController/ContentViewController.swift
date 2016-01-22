//
//  ContentViewController.swift
//  iEnglish
//
//  Created by Dareen Hsu on 1/4/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    var currentIndex : NSInteger?
    let manager : IEManager = IEManager.sharedInstance

    @IBOutlet weak var wordLabel : UILabel?
    @IBOutlet weak var sentenceLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.currentIndex = currentIndex!
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        setDefaultData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDefaultData() {
        let entity : WordEntity = manager.words?.objectAtIndex(currentIndex!) as! WordEntity
        wordLabel?.text = entity.word

        let str : NSMutableString! = NSMutableString.init()
        let sEntity : SentenceEntity? = SentenceEntity.getSentence(entity)
        str.appendFormat("%@\n", sEntity!.sentence!)

        sentenceLabel?.text = str.description
    }
}