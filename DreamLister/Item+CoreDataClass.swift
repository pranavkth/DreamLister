//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by pranav gupta on 30/01/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    // This function is called everytime an item is created.
    
    public override func awakeFromInsert() {
        //super.awake is required as it is specified in apple documentation.
        
        super.awakeFromInsert()
        self.created = NSDate()
    }

}
