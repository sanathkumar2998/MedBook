//
//  BookmarkDetailsDataStore.swift
//  MedBook
//
//  Created by Sanath on 19/04/24.
//

import Foundation
import CoreData

protocol BookmarkDetailsDataStoreLogic {    
    typealias FetchFromLocalCompletion = (Result<[BookmarkDetails], Error>) -> Void
    func fetchFromLocal(completion: FetchFromLocalCompletion)
    
    typealias BookmarkCompletion = (Result<Bool, Error>) -> Void
    func addBookmark(bookDetails: BookDetails, completion: BookmarkCompletion)
    func removeBookmark(key: String, completion: BookmarkCompletion)
}

final class BookmarkDetailsDataStore {
    let coreData: CoreDataProtocol
    
    init(coreData: CoreDataProtocol) {
        self.coreData = coreData
    }
}

// MARK: - CountryDetailsDataStoreLogic

extension BookmarkDetailsDataStore: BookmarkDetailsDataStoreLogic {
    func fetchFromLocal(completion: (Result<[BookmarkDetails], Error>) -> Void) {
        let context = coreData.managedObjectContext
        
        let fetchRequest = BookmarkDetails.fetchRequest()
        
        do {
            let data = try context.fetch(fetchRequest)
            completion(.success(data))
        } catch {
            debugPrint(error)
            completion(.failure(error))
        }
    }
    
    func addBookmark(bookDetails: BookDetails, completion: BookmarkCompletion) {
        let context = coreData.managedObjectContext
        
        let bookmarkDetails = BookmarkDetails(context: context)
        bookmarkDetails.encode(bookDetails)
        
        do {
            try coreData.saveContext()
            completion(.success(true))
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
    
    func removeBookmark(key: String, completion: BookmarkCompletion) {
        let context = coreData.managedObjectContext
        
        let fetchRequest = BookmarkDetails.fetchRequest()
        let predicate = NSPredicate(format: "key == %@", key)
        fetchRequest.predicate = predicate
        
        do {
            let bookmarks = try context.fetch(fetchRequest)
            for item in bookmarks {
                context.delete(item)
            }
            try coreData.saveContext()
            completion(.success(true))
        } catch let error as NSError {
            debugPrint("Could not delete. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
}
