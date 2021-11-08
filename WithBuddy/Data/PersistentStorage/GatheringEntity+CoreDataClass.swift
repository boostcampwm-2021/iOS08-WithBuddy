//
//  GatheringEntity+CoreDataClass.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/08.
//
//

import Foundation
import CoreData

@objc(GatheringEntity)
public class GatheringEntity: NSManagedObject {
    @NSManaged public var date: Date
    @NSManaged public var place: String?
    @NSManaged public var placeType: [Int]
    @NSManaged public var memo: String?
    @NSManaged public var picture: [URL]?
    @NSManaged public var buddy: NSSet
}

extension GatheringEntity {
    convenience init(context: NSManagedObjectContext, gathering: Gathering) {
        self.init(context: context)
        self.date = gathering.date
        self.place = gathering.place
        self.placeType = gathering.placeType
        self.memo = gathering.memo
        self.picture = gathering.picture
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GatheringEntity> {
        return NSFetchRequest<GatheringEntity>(entityName: "GatheringEntity")
    }
    
    @objc(addBuddyObject:)
    @NSManaged public func addToBuddy(_ value: BuddyEntity)

    @objc(removeBuddyObject:)
    @NSManaged public func removeFromBuddy(_ value: BuddyEntity)

    @objc(addBuddy:)
    @NSManaged public func addToBuddy(_ values: NSSet)

    @objc(removeBuddy:)
    @NSManaged public func removeFromBuddy(_ values: NSSet)
}
