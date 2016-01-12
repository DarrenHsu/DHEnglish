//
//  SentenceEntity+CoreDataProperties.swift
//  iEnglish
//
//  Created by Dareen Hsu on 1/5/16.
//  Copyright © 2016 D.H. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension NSManagedObject {

    @NSManaged var sentence: String?
    @NSManaged var rs_Word: WordEntity?

}
