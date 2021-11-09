//
//  BuddyEntity+CoreDataClass.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/08.
//
//

import Foundation
import CoreData

@objc(BuddyEntity)
public class BuddyEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var face: String
    @NSManaged public var gathering: Set<GatheringEntity>?
}

extension BuddyEntity {
    @discardableResult
    convenience init(context: NSManagedObjectContext, buddy: Buddy) {
        self.init(context: context)
        self.id = buddy.id
        self.name = buddy.name
        self.face = buddy.face
    }
    
    var buddy: Buddy {
        return Buddy(id: self.id, name: self.name, face: self.face)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuddyEntity> {
        return NSFetchRequest<BuddyEntity>(entityName: "BuddyEntity")
    }
    
    @objc(addGatheringObject:)
    @NSManaged public func addToGathering(_ value: GatheringEntity)

    @objc(removeGatheringObject:)
    @NSManaged public func removeFromGathering(_ value: GatheringEntity)

    @objc(addGathering:)
    @NSManaged public func addToGathering(_ values: NSSet)

    @objc(removeGathering:)
    @NSManaged public func removeFromGathering(_ values: NSSet)
}
