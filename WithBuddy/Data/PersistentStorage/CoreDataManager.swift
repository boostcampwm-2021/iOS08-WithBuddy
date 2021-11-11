//
//  CoreDataManager.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/08.
//

import CoreData

protocol CoreDataManagable {
    
    @discardableResult func insertGathering(_ gathering: Gathering) -> Bool
    @discardableResult func insertBuddy(_ buddy: Buddy) -> Bool
    func fetchAllBuddy() -> [BuddyEntity]
    func fetchAllGathering() -> [GatheringEntity]
    func fetchBuddy(name: String) -> [BuddyEntity]
    func fetchGathering(including name: String) -> [GatheringEntity]
    func fetchGathering(including day: Date) -> [GatheringEntity]
    func fetchGaterhing(month: Date) -> [GatheringEntity]
}

final class CoreDataManager {

    static let shared = CoreDataManager()
    
    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WithBuddyModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    private func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func fetchBuddyEntity(of buddyList: [Buddy]) -> [BuddyEntity] {
        let request = BuddyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", buddyList.map{ $0.id })
        return self.fetch(request: request)
    }
    
}

extension CoreDataManager: CoreDataManagable {
    
    func fetchAllBuddy() -> [BuddyEntity] {
        return self.fetch(request: BuddyEntity.fetchRequest()).sorted()
    }
    
    func fetchAllGathering() -> [GatheringEntity] {
        return self.fetch(request: GatheringEntity.fetchRequest()).sorted(by: >)
    }
    
    func fetchBuddy(name: String) -> [BuddyEntity] {
        let request = BuddyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        return self.fetch(request: request)
    }
    
    func fetchGathering(including name: String) -> [GatheringEntity] {
        return self.fetchBuddy(name: name).compactMap{ $0.gatheringList }.map{ Array($0) }.compactMap{ $0 }.flatMap{ $0 }.sorted(by: >)
    }
    
    func fetchGathering(including day: Date) -> [GatheringEntity] {
        let midnightOfDay = Calendar.current.startOfDay(for: day)
        
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "startDate <= %@ AND endDate >= %@", midnightOfDay as NSDate, midnightOfDay as NSDate)
        return self.fetch(request: request)
    }
    
    func fetchGaterhing(month: Date) -> [GatheringEntity] {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: month)
        components.day = 1
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDateOfMonth = calendar.date(from: components) ?? Date()
        let endDateOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDateOfMonth) ?? Date()
        
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "startDate >= %@ AND startDate <= %@", startDateOfMonth as NSDate, endDateOfMonth as NSDate)
        return self.fetch(request: request)
    }
    
    @discardableResult
    func insertBuddy(_ buddy: Buddy) -> Bool {
        BuddyEntity(context: self.context, buddy: buddy)
        
        do {
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func insertGathering(_ gathering: Gathering) -> Bool {
        let gatheringEntity = GatheringEntity(context: self.context, gathering: gathering)
        gatheringEntity.addToBuddyList(NSSet(array: self.fetchBuddyEntity(of: gathering.buddyList)))
        
        do {
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
