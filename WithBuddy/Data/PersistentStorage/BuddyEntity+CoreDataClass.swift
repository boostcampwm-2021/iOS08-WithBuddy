//
//  BuddyEntity+CoreDataClass.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/10.
//
//

import Foundation
import CoreData

@objc(BuddyEntity)
public final class BuddyEntity: NSManagedObject {
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var face: String
    @NSManaged public var gatheringList: Set<GatheringEntity>
    
}

extension BuddyEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuddyEntity> {
        return NSFetchRequest<BuddyEntity>(entityName: "BuddyEntity")
    }
    
    @objc(addGatheringListObject:)
    @NSManaged public func addToGatheringList(_ value: GatheringEntity)

    @objc(removeGatheringListObject:)
    @NSManaged public func removeFromGatheringList(_ value: GatheringEntity)

    @objc(addGatheringList:)
    @NSManaged public func addToGatheringList(_ values: NSSet)

    @objc(removeGatheringList:)
    @NSManaged public func removeFromGatheringList(_ values: NSSet)
    
}

extension BuddyEntity {
    
    @discardableResult
    convenience init(context: NSManagedObjectContext, buddy: Buddy) {
        self.init(context: context)
        self.id = buddy.id
        self.name = buddy.name
        self.face = buddy.face
    }
    
    func toDomain() -> Buddy {
        return Buddy(id: self.id,
                     name: self.name,
                     face: self.face)
    }
    
    func findRecentlyDate(before date: Date) -> Date? {
        for gatheringEntity in self.gatheringList.sorted(by: >) where gatheringEntity.date <= date {
            return gatheringEntity.date
        }
        return nil
    }
    
}

extension BuddyEntity: Comparable {
    
    public static func < (lhs: BuddyEntity, rhs: BuddyEntity) -> Bool {
        return lhs.name < rhs.name
    }
    
}
