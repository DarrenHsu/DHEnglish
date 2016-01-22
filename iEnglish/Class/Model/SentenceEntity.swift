//
//  SentenceEntity.swift
//  iEnglish
//
//  Created by Dareen Hsu on 1/5/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import Foundation
import CoreData

@objc(SentenceEntity)
class SentenceEntity: NSManagedObject {

    //MARK: - Predicate
    static func appendPredicate(pre : NSPredicate?, sentence : String?) -> NSPredicate? {
        if (sentence != nil) {
            let p : NSPredicate = NSPredicate.init(format: "sentence == %@", sentence!)
            if (pre != nil) {
                return NSCompoundPredicate.init(andPredicateWithSubpredicates: [p, pre!])
            }else {
                return p
            }
        }else {
            return (pre != nil) ? pre : NSPredicate.init(value: true)
        }
    }

    static func appendPredicate(pre : NSPredicate?, wEntity : WordEntity?) -> NSPredicate? {
        if (wEntity != nil) {
            let p : NSPredicate = NSPredicate.init(format: "rs_Word == %@", wEntity!)
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
    static func addSentence(sentence : String?, wEntity : WordEntity!, context : NSManagedObjectContext!) {
        let pre : NSPredicate = appendPredicate(nil, sentence: sentence)!
        var entity : SentenceEntity? = SentenceEntity.MR_findFirstWithPredicate(pre, inContext: context)
        if (entity == nil) {
            entity = SentenceEntity.MR_createEntityInContext(context)
        }

        entity?.sentence = sentence
        entity?.rs_Word = wEntity
    }

    static func getSentence(wEntity : WordEntity) -> SentenceEntity {
        print("<DB> \(NSStringFromSelector(__FUNCTION__)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.MR_defaultContext()
        let pre : NSPredicate! = appendPredicate(nil, wEntity: wEntity)
        let result : SentenceEntity! = SentenceEntity.MR_findFirstWithPredicate(pre, inContext: context)

        print("<DB> \(NSStringFromSelector(__FUNCTION__)) end")

        return result
    }

    static func deleteSentence(wEntity : WordEntity? , context : NSManagedObjectContext?) {
        print("<DB> \(NSStringFromSelector(__FUNCTION__)) start")

        let pre : NSPredicate = appendPredicate(nil, wEntity: wEntity)!
        let sEntities : [SentenceEntity]! = SentenceEntity.MR_findAllWithPredicate(pre, inContext: context) as! [SentenceEntity]

        for sEntity in sEntities! {
            sEntity.deleteInContext(context)
        }

        print("<DB> \(NSStringFromSelector(__FUNCTION__)) end")
    }

    func delete() {
        let context : NSManagedObjectContext! = NSManagedObjectContext.MR_defaultContext()
        deleteInContext(context)
    }

    func deleteInContext(context : NSManagedObjectContext?) {
        let entity : SentenceEntity? = self.MR_inContext(context)
        entity?.MR_deleteEntityInContext(context)
    }
}