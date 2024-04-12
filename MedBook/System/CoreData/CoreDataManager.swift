//
//  CoreDataManager.swift
//  MedBook
//
//  Created by Sanath on 11/04/24.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case noChangesInContext
    case generic
    case entityNameNotValid
}

protocol CoreDataProtocol {
    var managedObjectContext: NSManagedObjectContext { get }
    func saveContext() throws
}

final class CoreDataManager: CoreDataProtocol {
    
    static let shared = CoreDataManager()

    // MARK: - Properties

    private var modelName: String = "MedBook"

    // MARK: - Initialization

    private init() { }
    
    // MARK: - Core Data Stack

    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    func saveContext() throws {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                throw nserror
            }
        }
    }
    
    func delete(entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
            
            try saveContext()
        } catch {
            
        }
    }
}
