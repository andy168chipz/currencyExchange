//
//  Rate+CoreDataProperties.swift
//  
//
//  Created by Andy Chou on 4/9/19.
//
//

import Foundation
import CoreData


extension Rate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rate> {
        return NSFetchRequest<Rate>(entityName: "Rate")
    }

    @NSManaged public var rate: Float
    @NSManaged public var currency: Currency?

}
