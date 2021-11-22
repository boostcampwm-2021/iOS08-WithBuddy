//
//  PurposeEntity+CoreDataClass.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/22.
//
//

import Foundation
import CoreData

@objc(PurposeEntity)
public class PurposeEntity: NSManagedObject {
    
    @NSManaged public var name: String
    @NSManaged public var gatheringList: Set<GatheringEntity>
    
}

extension PurposeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PurposeEntity> {
        return NSFetchRequest<PurposeEntity>(entityName: "PurposeEntity")
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

extension PurposeEntity {
    
    @discardableResult
    convenience init(context: NSManagedObjectContext, purpose: PlaceType) {
        self.init(context: context)
        self.name = purpose.description
    }
    
    func toDomain() -> PlaceType? {
        return PlaceType(rawValue: self.name)
    }
    
}
