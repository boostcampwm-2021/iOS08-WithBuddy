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
    @discardableResult func updateBuddy(_ buddy: Buddy) -> Bool
    @discardableResult func deleteBuddy(_ buddy: Buddy) throws -> Bool
    func fetchAllBuddy() -> [BuddyEntity]
    func fetchAllGathering() -> [GatheringEntity]
    func fetchBuddy(name: String) -> [BuddyEntity]
    func fetchGathering(including name: String) -> [GatheringEntity]
    func fetchGathering(including day: Date) -> [GatheringEntity]
    func fetchGaterhing(month: Date) -> [GatheringEntity]
    func updateGathering(_ gathering: Gathering)
}

final class CoreDataManager {

    static let shared = CoreDataManager()
    let calendarUseCase = CalendarUseCase()
    
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
        let midnightOfDay = self.calendarUseCase.firstTimeOfDay(baseDate: day)
        let midnightOfNextDay = self.calendarUseCase.nextDay(baseDate: midnightOfDay)
        
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", midnightOfDay as NSDate, midnightOfNextDay as NSDate)
        return self.fetch(request: request)
    }
    
    func fetchGaterhing(month: Date) -> [GatheringEntity] {
        let startDateOfMonth = self.calendarUseCase.firstDateOfMonth(baseDate: month)
        let startDateOfNextMonth = self.calendarUseCase.nextMonth(baseDate: startDateOfMonth)
        
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startDateOfMonth as NSDate, startDateOfNextMonth as NSDate)
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
    
    @discardableResult
    func updateBuddy(_ buddy: Buddy) -> Bool {
        let request = BuddyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", buddy.id as CVarArg )
        
        guard let buddyEntity = self.fetch(request: request).first else { return false }
        buddyEntity.name = buddy.name
        buddyEntity.face = buddy.face
        
        do {
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func deleteBuddy(_ buddy: Buddy) throws -> Bool {
        let request = BuddyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", buddy.id as CVarArg )
        
        guard let buddyEntity = self.fetch(request: request).first else { return false }
        if let gatheringList = buddyEntity.gatheringList,
           !gatheringList.isEmpty {
            throw BuddyChoiceError.oneMoreGathering
        }
        
        self.context.delete(buddyEntity)
        
        do {
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func updateGathering(_ gathering: Gathering) {
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", gathering.id as CVarArg)
        
        guard let gatheringEntity = self.fetch(request: request).first else { return }
        gatheringEntity.date = gathering.date
        gatheringEntity.place = gathering.place
        gatheringEntity.purpose = gathering.purpose
        gatheringEntity.memo = gathering.memo
        gatheringEntity.picture = gathering.picture
        gatheringEntity.buddyList.forEach{ buddyEntity in
            gatheringEntity.removeFromBuddyList(buddyEntity)
        }
        gatheringEntity.addToBuddyList(NSSet(array: self.fetchBuddyEntity(of: gathering.buddyList)))
        
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
