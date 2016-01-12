//
//  AddViewController.swift
//  iEnglish
//
//  Created by Dareen Hsu on 12/22/15.
//  Copyright © 2015 D.H. All rights reserved.
//

import UIKit

class AddViewController: BaseViewController {

    @IBOutlet weak var wordField : UITextField?
    @IBOutlet weak var sentenceTextView: UITextView?

    @IBAction func submitPressed(sender : UIButton) {
        if !checkData() {
            return
        }

        WordEntity.addWord(wordField?.text, sentence: sentenceTextView?.text)
        wordField?.text = ""
        sentenceTextView?.text = ""
        showAlert("Add Success!")
    }

    private func checkData() -> Bool {
        if wordField!.text!.isEmpty {
            showAlert("Oops... Please input word!")
            return false
        }

        if sentenceTextView!.text.isEmpty {
            showAlert("Oops... Please input sentence!")
            return false
        }

        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.title = "Add Word"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}