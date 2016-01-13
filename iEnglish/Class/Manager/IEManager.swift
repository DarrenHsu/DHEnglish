//
//  IEManager.swift
//  iEnglish
//
//  Created by Dareen Hsu on 1/6/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

class IEManager: NSObject {
    static let sharedInstance = IEManager()

    var words : NSArray?
    var count : NSInteger?
    var currentIndex : NSInteger = 0

    func getCurrentWords() {
        words = WordEntity.getWords()
        count = (NSInteger)(WordEntity.getCount())
    }
}