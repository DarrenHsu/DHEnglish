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
        let entity : WordEntity = manager.words?.object(at: currentIndex!) as! WordEntity
        wordLabel?.text = entity.word
        chinessLabel?.text = entity.chiness

        let sEntity : SentenceEntity? = SentenceEntity.getSentence(entity)

        sentenceLabel?.text = sEntity?.sentence
    }
}
