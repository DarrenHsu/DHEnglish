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
    static func appendPredicate(_ pre : NSPredicate?, sentence : String?) -> NSPredicate? {
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

    static func appendPredicate(_ pre : NSPredicate?, wEntity : WordEntity?) -> NSPredicate? {
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
    static func addSentence(_ sentence : String?, wEntity : WordEntity!, context : NSManagedObjectContext!) {
        let pre : NSPredicate = appendPredicate(nil, sentence: sentence)!
        var entity : SentenceEntity? = SentenceEntity.mr_findFirst(with: pre, in: context)
        if (entity == nil) {
            entity = SentenceEntity.mr_createEntity(in: context)
        }

        entity?.sentence = sentence
        entity?.rs_Word = wEntity
    }

    static func getSentence(_ wEntity : WordEntity) -> SentenceEntity {
        print("<DB> \(NSStringFromSelector(#function)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.mr_default()
        let pre : NSPredicate! = appendPredicate(nil, wEntity: wEntity)
        let result : SentenceEntity! = SentenceEntity.mr_findFirst(with: pre, in: context)

        print("<DB> \(NSStringFromSelector(#function)) end")

        return result
    }

    static func deleteSentence(_ wEntity : WordEntity? , context : NSManagedObjectContext?) {
        print("<DB> \(NSStringFromSelector(#function)) start")

        let pre : NSPredicate = appendPredicate(nil, wEntity: wEntity)!
        let sEntities : [SentenceEntity]! = SentenceEntity.mr_findAll(with: pre, in: context) as! [SentenceEntity]

        for sEntity in sEntities! {
            sEntity.deleteInContext(context)
        }

        print("<DB> \(NSStringFromSelector(#function)) end")
    }

    func delete() {
        let context : NSManagedObjectContext! = NSManagedObjectContext.mr_default()
        deleteInContext(context)
    }

    func deleteInContext(_ context : NSManagedObjectContext?) {
        let entity : SentenceEntity? = self.mr_(in: context)
        entity?.mr_deleteEntity(in: context)
    }
}
