//
//  GatheringEntity+CoreDataClass.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/10.
//
//

import Foundation
import CoreData

@objc(GatheringEntity)
public class GatheringEntity: NSManagedObject {
    
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var purpose: [String]
    @NSManaged public var place: String?
    @NSManaged public var memo: String?
    @NSManaged public var picture: [URL]?
    @NSManaged public var buddyList: Set<BuddyEntity>
    
}

extension GatheringEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GatheringEntity> {
        return NSFetchRequest<GatheringEntity>(entityName: "GatheringEntity")
    }
    
    @objc(addBuddyListObject:)
    @NSManaged public func addToBuddyList(_ value: BuddyEntity)

    @objc(removeBuddyListObject:)
    @NSManaged public func removeFromBuddyList(_ value: BuddyEntity)

    @objc(addBuddyList:)
    @NSManaged public func addToBuddyList(_ values: NSSet)

    @objc(removeBuddyList:)
    @NSManaged public func removeFromBuddyList(_ values: NSSet)
    
}

extension GatheringEntity {
    
    convenience init(context: NSManagedObjectContext, gathering: Gathering) {
        self.init(context: context)
        self.startDate = gathering.startDate
        self.endDate = gathering.endDate
        self.place = gathering.place
        self.purpose = gathering.purpose
        self.memo = gathering.memo
        self.picture = gathering.picture
    }
    
    func toDomain() -> Gathering {
        return Gathering(startDate: self.startDate,
                         endDate: self.endDate,
                         place: self.place,
                         placeType: self.purpose,
                         buddy: self.buddyList.map{ $0.toDomain() },
                         memo: self.memo,
                         picture: self.picture)
    }
}
