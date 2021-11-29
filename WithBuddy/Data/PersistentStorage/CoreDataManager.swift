//
//  CoreDataManager.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/08.
//

import CoreData
import Combine

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
    func fetchGathering(month: Date) -> [GatheringEntity]
    func fetchGathering(oneWeekFrom date: Date) -> [GatheringEntity]
    func updateGathering(_ gathering: Gathering)
    func deleteGathering(_ gatheringId: UUID)
    func fetchPurpose() -> AnyPublisher<[PurposeEntity], Never>
    func deleteAllGathering() -> AnyPublisher<Void, CoreDataManager.CoreDataError>
    
}

final class CoreDataManager {
    
    enum CoreDataError: LocalizedError {
        case deleteFail
        
        var errorDescription: String? {
            return "삭제에 실패하셨습니다."
        }
    }
    
    static let shared = CoreDataManager()
    let calendarUseCase = CalendarUseCase()
    
    private init() {
        self.context.perform { [weak self] in
            guard let self = self,
                  let purpose = try? self.context.fetch(PurposeEntity.fetchRequest()) else { return }
            if purpose.count != PurposeCategory.allCases.count {
                let purposeList = purpose.map{ $0.toDomain() }
                for place in PurposeCategory.allCases where !purposeList.contains(place) {
                    PurposeEntity(context: self.context, purpose: place)
                }
                try? self.context.save()
            }
        }
    }
    
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
    
    private func fetchPurposeEntity(of purposeList: [String]) -> [PurposeEntity] {
        let request = PurposeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name IN %@", purposeList)
        return self.fetch(request: request)
    }
    
}

extension CoreDataManager: CoreDataManagable {
    
    func fetchAllBuddy() -> [BuddyEntity] {
        return self.fetch(request: BuddyEntity.fetchRequest()).sorted(by: >)
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
        return self.fetch(request: request).sorted(by: >)
    }
    
    func fetchGathering(month: Date) -> [GatheringEntity] {
        let startDateOfMonth = self.calendarUseCase.firstDateOfMonth(baseDate: month)
        let startDateOfNextMonth = self.calendarUseCase.nextMonth(baseDate: startDateOfMonth)
        
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startDateOfMonth as NSDate, startDateOfNextMonth as NSDate)
        return self.fetch(request: request).sorted(by: >)
    }
    
    func fetchGathering(oneWeekFrom date: Date) -> [GatheringEntity] {
        let startTimeOfDay = self.calendarUseCase.firstTimeOfDay(baseDate: date)
        let startTimeOfNext8Day = self.calendarUseCase.next8Days(baseDate: startTimeOfDay)
        
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startTimeOfDay as NSDate, startTimeOfNext8Day as NSDate)
        return self.fetch(request: request).sorted(by: >)
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
        gatheringEntity.addToPurposeList(NSSet(array: self.fetchPurposeEntity(of: gathering.purpose)))
        
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
        if !buddyEntity.gatheringList.isEmpty {
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
        gatheringEntity.memo = gathering.memo
        gatheringEntity.picture = gathering.picture
        gatheringEntity.purposeList.forEach{ purposeEntity in
            gatheringEntity.removeFromPurposeList(purposeEntity)
        }
        gatheringEntity.addToPurposeList(NSSet(array: self.fetchPurposeEntity(of: gathering.purpose)))
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
    
    func deleteGathering(_ gatheringId: UUID) {
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", gatheringId as CVarArg)
        
        guard let gatheringEntity = self.fetch(request: request).first else { return }
        self.context.delete(gatheringEntity)
        
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchPurpose() -> AnyPublisher<[PurposeEntity], Never> {
        let request = PurposeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "gatheringList.@count > 0")
        return Just(self.fetch(request: request))
            .map{ $0.sorted(by: { lhs, rhs in
                lhs.gatheringList.count > rhs.gatheringList.count
            })}
            .eraseToAnyPublisher()
    }
    
    func deleteAllGathering() -> AnyPublisher<Void, CoreDataError> {
        return Future { promise in
            do {
                let list = self.fetch(request: GatheringEntity.fetchRequest())
                list.forEach{ self.context.delete($0) }
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(.deleteFail))
            }
        }.eraseToAnyPublisher()
    }
    
}
