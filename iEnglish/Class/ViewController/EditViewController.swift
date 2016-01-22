//
//  EditViewController.swift
//  DHEnglish
//
//  Created by Dareen Hsu on 1/22/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

class EditViewController: BaseViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var wordField : UITextField?
    @IBOutlet weak var sentenceTextView: UITextView?

    var selectWord : WordEntity?

    @IBAction func submitPressed(sender : UIButton) {
        if !checkData() {
            return
        }

        selectWord?.update(wordField?.text, sentence: sentenceTextView?.text)
        showAlert("Update Success!")
    }

    @IBAction func backPressed(sender : UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
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

        let tap : UITapGestureRecognizer! = UITapGestureRecognizer.init(target: self, action: Selector("tapRecognizer:"))
        self.view.addGestureRecognizer(tap)

        wordField?.delegate = self
        setDefaultValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDefaultValue() {
        if (selectWord != nil) {
            wordField?.text = selectWord?.word
            let sEntity : SentenceEntity? = SentenceEntity.getSentence(selectWord!)
            sentenceTextView?.text = sEntity?.sentence
        }
    }

    func tapRecognizer(recognizer : UITapGestureRecognizer!) {
        wordField?.resignFirstResponder()
        sentenceTextView?.resignFirstResponder()
    }

    // MARK: UITextViewDelegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
