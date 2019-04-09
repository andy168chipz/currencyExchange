//
//  Currency+CoreDataProperties.swift
//  
//
//  Created by Andy Chou on 4/9/19.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var country: String?
    @NSManaged public var currency: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var rate: NSOrderedSet?

}

// MARK: Generated accessors for rate
extension Currency {

    @objc(insertObject:inRateAtIndex:)
    @NSManaged public func insertIntoRate(_ value: Rate, at idx: Int)

    @objc(removeObjectFromRateAtIndex:)
    @NSManaged public func removeFromRate(at idx: Int)

    @objc(insertRate:atIndexes:)
    @NSManaged public func insertIntoRate(_ values: [Rate], at indexes: NSIndexSet)

    @objc(removeRateAtIndexes:)
    @NSManaged public func removeFromRate(at indexes: NSIndexSet)

    @objc(replaceObjectInRateAtIndex:withObject:)
    @NSManaged public func replaceRate(at idx: Int, with value: Rate)

    @objc(replaceRateAtIndexes:withRate:)
    @NSManaged public func replaceRate(at indexes: NSIndexSet, with values: [Rate])

    @objc(addRateObject:)
    @NSManaged public func addToRate(_ value: Rate)

    @objc(removeRateObject:)
    @NSManaged public func removeFromRate(_ value: Rate)

    @objc(addRate:)
    @NSManaged public func addToRate(_ values: NSOrderedSet)

    @objc(removeRate:)
    @NSManaged public func removeFromRate(_ values: NSOrderedSet)

}
