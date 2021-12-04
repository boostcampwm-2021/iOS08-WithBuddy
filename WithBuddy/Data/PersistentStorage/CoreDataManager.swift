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
    func fetchAllGathering() -> [GatheringEntity]
    func fetchGathering(including name: String) -> [GatheringEntity]
    func fetchGathering(including day: Date) -> [GatheringEntity]
    func fetchGathering(month: Date) -> [GatheringEntity]
    func fetchGathering(oneWeekFrom date: Date) -> [GatheringEntity]
    func updateGathering(_ gathering: Gathering)
    func deleteGathering(_ gatheringId: UUID)
    func fetchPurpose() -> AnyPublisher<[PurposeEntity], Never>
    func deleteAllGathering() -> AnyPublisher<Void, CoreDataManager.CoreDataError>
    func fetchGathering(id: UUID) -> GatheringEntity?
    
}

protocol BuddyManagable {
    
    func insertBuddy(_ buddy: Buddy) -> AnyPublisher<BuddyEntity, CoreDataManager.CoreDataError>
    func fetchAllBuddy() -> AnyPublisher<[BuddyEntity], CoreDataManager.CoreDataError>
    func updateBuddy(_ buddy: Buddy) -> AnyPublisher<BuddyEntity, CoreDataManager.CoreDataError>
    func deleteBuddy(_ buddy: Buddy) -> AnyPublisher<Void, CoreDataManager.CoreDataError>
    
}

final class CoreDataManager {
    
    enum CoreDataError: LocalizedError {
        case oneMoreGathering
        case buddyInsert
        case buddyFetch
        case buddyUpdate
        case buddyDelete
        case gatheringInsert
        case gatheringFetch
        case gatheringUpdate
        case gatheringDelete
        
        var errorDescription: String? {
            switch self {
            case .oneMoreGathering: return "버디가 하나 이상의 모임에 속해있습니다."
            case .buddyInsert: return "버디를 생성할 수 없습니다."
            case .buddyFetch: return "버디를 불러올 수 없습니다."
            case .buddyUpdate: return "버디를 수정할 수 없습니다."
            case .buddyDelete: return "버디를 삭제할 수 없습니다."
            case .gatheringInsert: return "모임을 생성할 수 없습니다."
            case .gatheringFetch: return "모임을 불러올 수 없습니다."
            case .gatheringUpdate: return "모임을 수정할 수 없습니다."
            case .gatheringDelete: return "모임을 삭제할 수 없습니다."
            }
        }
    }
    
    static let shared = CoreDataManager()
    private let calendarUseCase: CalendarUseCase
    
    private init(calendarUseCase: CalendarUseCase = CalendarUseCase()) {
        self.calendarUseCase = calendarUseCase
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
    
    private lazy var context: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
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
        guard let fetchResult = try? self.backgroundContext.fetch(request) else { return [] }
        return fetchResult
    }
    
    private func fetchPurposeEntity(of purposeList: [String]) -> [PurposeEntity] {
        let request = PurposeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name IN %@", purposeList)
        guard let fetchResult = try? self.backgroundContext.fetch(request) else { return [] }
        return fetchResult
    }
    
}

extension CoreDataManager: BuddyManagable {
    
    func fetchAllBuddy() -> AnyPublisher<[BuddyEntity], CoreDataError> {
        return Future { promise in
            self.backgroundContext.perform {
                do {
                    let request = BuddyEntity.fetchRequest()
                    let fetchResult = try self.backgroundContext.fetch(request)
                    promise(.success(fetchResult.sorted()))
                } catch {
                    promise(.failure(.buddyFetch))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func insertBuddy(_ buddy: Buddy) -> AnyPublisher<BuddyEntity, CoreDataError> {
        return Future { promise in
            self.backgroundContext.perform {
                let buddyEntity = BuddyEntity(context: self.backgroundContext, buddy: buddy)
                do {
                    try self.backgroundContext.save()
                    promise(.success(buddyEntity))
                } catch {
                    promise(.failure(.buddyInsert))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateBuddy(_ buddy: Buddy) -> AnyPublisher<BuddyEntity, CoreDataError> {
        return Future { promise in
            self.backgroundContext.perform {
                let request = BuddyEntity.fetchRequest()
                request.predicate = NSPredicate(
                    format: "%K == %@",
                    #keyPath(BuddyEntity.id),
                    buddy.id as CVarArg
                )
                do {
                    let fetchResult = try self.backgroundContext.fetch(request)
                    guard let buddyEntity = fetchResult.first else { return }
                    buddyEntity.name = buddy.name
                    buddyEntity.face = buddy.face
                    
                    if self.backgroundContext.hasChanges {
                        try self.backgroundContext.save()
                    }
                    promise(.success(buddyEntity))
                } catch {
                    promise(.failure(.buddyUpdate))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteBuddy(_ buddy: Buddy) -> AnyPublisher<Void, CoreDataError> {
        return Future { promise in
            self.backgroundContext.perform {
                let request = BuddyEntity.fetchRequest()
                request.predicate = NSPredicate(
                    format: "%K == %@",
                    #keyPath(BuddyEntity.id) ,
                    buddy.id as CVarArg
                )
                do {
                    let fetchResult = try self.backgroundContext.fetch(request)
                    guard let buddyEntity = fetchResult.first else { return }
                    if !buddyEntity.gatheringList.isEmpty {
                        promise(.failure(.oneMoreGathering))
                    } else {
                        self.backgroundContext.delete(buddyEntity)
                        try self.backgroundContext.save()
                        promise(.success(()))
                    }
                } catch {
                    promise(.failure(.buddyDelete))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}

extension CoreDataManager: CoreDataManagable {
    
    func fetchAllGathering() -> [GatheringEntity] {
        return self.fetch(request: GatheringEntity.fetchRequest()).sorted(by: >)
    }
    
    func fetchGathering(including name: String) -> [GatheringEntity] {
        return []
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
                promise(.failure(.gatheringDelete))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchGathering(id: UUID) -> GatheringEntity? {
        let request = GatheringEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(GatheringEntity.id),
            id as CVarArg
        )
        return self.fetch(request: request).first
    }
    
}
