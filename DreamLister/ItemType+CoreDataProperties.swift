//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by pranav gupta on 30/01/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
