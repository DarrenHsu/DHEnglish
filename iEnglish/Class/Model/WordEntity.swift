//
//  WordEntity.swift
//  iEnglish
//
//  Created by Dareen Hsu on 1/5/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import Foundation
import CoreData

@objc(WordEntity)
class WordEntity: NSManagedObject {

    //MARK: - Predicate
    static func appendPredicate(pre : NSPredicate?, word : String?) -> NSPredicate? {
        if (word != nil) {
            let p : NSPredicate = NSPredicate.init(format: "word == %@", word!)
            if (pre != nil) {
                return NSCompoundPredicate.init(andPredicateWithSubpredicates: [p, pre!])
            }else {
                return p
            }
        }else {
            return (pre != nil) ? pre : NSPredicate.init(value: true)
        }
    }

    //MARK: - Helper Methods
    static func getWords() -> NSArray! {
        print("<DB> \(NSStringFromSelector(__FUNCTION__)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.MR_defaultContext()
        let entities : [AnyObject]! = WordEntity.MR_findAllSortedBy("number", ascending: true, inContext: context!)
        let result : NSMutableArray! = NSMutableArray()
        result.addObjectsFromArray(entities)

        print("<DB> \(NSStringFromSelector(__FUNCTION__)) end")

        return result
    }

    static func getCount() -> UInt {
        print("<DB> \(NSStringFromSelector(__FUNCTION__)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.MR_defaultContext()
        let count : UInt = WordEntity.MR_countOfEntitiesWithContext(context)

        print("<DB> \(NSStringFromSelector(__FUNCTION__)) end")

        return count
    }

    static func addWord(word : String?) {
        MagicalRecord.saveWithBlockAndWait { (context : NSManagedObjectContext!) -> Void in
            print("<DB> \(NSStringFromSelector(__FUNCTION__)) start")

            let pre : NSPredicate = appendPredicate(nil, word: word)!
            var entity : WordEntity? = WordEntity.MR_findFirstWithPredicate(pre, inContext: context!)
            if (entity != nil) {
                let count : UInt = getCount()
                entity = WordEntity.MR_createEntityInContext(context!)
                entity?.number = count + 1
            }

            entity?.word = word

            print("<DB> \(NSStringFromSelector(__FUNCTION__)) end")
        }
    }

    static func addWord(word : String?, sentence : String?) {
        MagicalRecord.saveWithBlockAndWait { (context : NSManagedObjectContext!) -> Void in
            print("<DB> \(NSStringFromSelector(__FUNCTION__)) start")

            let pre : NSPredicate = appendPredicate(nil, word: word)!
            var entity : WordEntity? = WordEntity.MR_findFirstWithPredicate(pre, inContext: context!)
            if (entity == nil) {
                let count : UInt = getCount()
                entity = WordEntity.MR_createEntityInContext(context!)
                entity?.number = count + 1
            }

            entity?.word = word
            SentenceEntity.addSentence(sentence, wEntity: entity, context: context)
            
            print("<DB> \(NSStringFromSelector(__FUNCTION__)) end")
        }
    }
}