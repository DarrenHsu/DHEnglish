//
//  AddViewController.swift
//  DHEnglish
//
//  Created by Dareen Hsu on 1/22/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

class AddViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var wordField : UITextField?
    @IBOutlet weak var sentenceTextView: UITextView?

    @IBAction func submitPressed(sender : UIButton) {
        if !checkData() {
            return
        }

        WordEntity.addWord(wordField?.text, sentence: sentenceTextView?.text)
        wordField?.text = nil
        sentenceTextView?.text = nil
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

        let tap : UITapGestureRecognizer! = UITapGestureRecognizer.init(target: self, action: #selector(tapRecognizer))
        self.view.addGestureRecognizer(tap)

        wordField?.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidHide), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func keyboardWillShow(notification : NSNotification!) {
        let height : CGFloat = (self.wordField?.superview!.frame.origin.y)! - 55
        var frame : CGRect! = self.view.frame
        frame.origin.y = -height
        UIView.animateWithDuration(0.28, animations: {
            self.view.frame = frame
        })
    }

    func keyboardDidHide(notification : NSNotification!) {
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        UIView.animateWithDuration(0.28, animations: {
            self.view.frame = frame
        })
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
