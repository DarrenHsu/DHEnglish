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
    static func appendPredicate(_ pre : NSPredicate?, word : String?) -> NSPredicate? {
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
        print("<DB> \(NSStringFromSelector(#function)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.mr_default()
        let entities : [AnyObject]! = WordEntity.mr_findAllSorted(by: "number", ascending: false, in: context!) as [AnyObject]!
        let result : NSMutableArray! = NSMutableArray()
        result.addObjects(from: entities)

        print("<DB> \(NSStringFromSelector(#function)) end")

        return result
    }

    static func getCount() -> UInt {
        print("<DB> \(NSStringFromSelector(#function)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.mr_default()
        let count : UInt = WordEntity.mr_countOfEntities(with: context)

        print("<DB> \(NSStringFromSelector(#function)) end")

        return count
    }

    static func addWord(_ words : [Any]?, success : (() -> Void)?) {
        MagicalRecord.save({ (context) in
            for w in words! {
                let _w = w as! NSDictionary
                let no = _w["no"] as! NSNumber
                let word = _w["word"] as! String
                let sentence = _w["sentence"] as! String
                let chiness = _w["chiness"] as! String

                let pre : NSPredicate = appendPredicate(nil, word: word)!
                var entity : WordEntity? = WordEntity.mr_findFirst(with: pre, in: context!)
                if entity == nil {
                    entity = WordEntity.mr_createEntity(in: context!)
                    entity?.number = no
                }

                entity?.word = word
                entity?.chiness = chiness

                SentenceEntity.addSentence(sentence, wEntity: entity, context: context)
            }
        }) { (complete, error) in
            if complete && error == nil {
                success?()
            }
        }
    }

    static func addWord(_ word : String?, chiness : String) {
        MagicalRecord.save(blockAndWait: { (context) in
            print("<DB> \(NSStringFromSelector(#function)) start")

            let pre : NSPredicate = appendPredicate(nil, word: word)!
            var entity : WordEntity? = WordEntity.mr_findFirst(with: pre, in: context!)
            if entity == nil {
                let count : UInt = getCount()
                entity = WordEntity.mr_createEntity(in: context!)
                entity?.number = NSNumber(integerLiteral: Int(count) + 1)
            }

            entity?.word = word
            entity?.chiness = chiness

            print("<DB> \(NSStringFromSelector(#function)) end")
        })
    }

    static func addWord(_ word : String?, chiness : String?, sentence : String?) {
        MagicalRecord.save(blockAndWait: { (context) in
            print("<DB> \(NSStringFromSelector(#function)) start")

            let pre : NSPredicate = appendPredicate(nil, word: word)!
            var entity : WordEntity? = WordEntity.mr_findFirst(with: pre, in: context!)
            if entity == nil {
                let count : UInt = getCount()
                entity = WordEntity.mr_createEntity(in: context!)
                entity?.number = NSNumber(integerLiteral: Int(count) + 1)
            }

            entity?.word = word
            entity?.chiness = chiness
            SentenceEntity.addSentence(sentence, wEntity: entity, context: context)
            
            print("<DB> \(NSStringFromSelector(#function)) end")
        })
    }

    func update(_ word : String?, chiness : String?, sentence : String?) {
        MagicalRecord.save(blockAndWait: { (context) in
            print("<DB> \(NSStringFromSelector(#function)) start")

            let entity : WordEntity? = self.mr_(in: context)
            entity?.word = word
            entity?.chiness = chiness
            SentenceEntity.deleteSentence(entity, context: context)
            SentenceEntity.addSentence(sentence, wEntity: entity, context: context)

            print("<DB> \(NSStringFromSelector(#function)) end")
        })
    }

    func delete() {
        MagicalRecord.save(blockAndWait: { (context) in
            print("<DB> \(NSStringFromSelector(#function)) start")

            let entity : WordEntity? = self.mr_(in: context)
            entity?.mr_deleteEntity(in: context)

            print("<DB> \(NSStringFromSelector(#function)) end")
        })
    }
}
