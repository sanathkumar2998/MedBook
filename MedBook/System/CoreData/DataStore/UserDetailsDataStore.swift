//
//  UserDetailsDataStore.swift
//  MedBook
//
//  Created by Sanath on 11/04/24.
//

import Foundation

protocol UserDetailsDataStoreLogic {
    typealias InsertUserCompletion = (Result<Bool, Error>) -> Void
    func insertUser(email: String,
                    password: String,
                    country: String,
                    completion: InsertUserCompletion)
    
    typealias UserExistsCompletion = (Result<Bool, Error>) -> Void
    func checkIfUserExists(email: String,
                           password: String,
                           completion: UserExistsCompletion)
    
    typealias EmailExistsCompletion = (Result<Bool, Error>) -> Void
    func checkIfUserExists(email: String,
                           completion: EmailExistsCompletion)
}

final class UserDetailsDataStore {
    let coreData: CoreDataProtocol
    
    init(coreData: CoreDataProtocol) {
        self.coreData = coreData
    }
}

// MARK: - UserDetailsDataStoreLogic

extension UserDetailsDataStore: UserDetailsDataStoreLogic {
    func insertUser(email: String,
                    password: String,
                    country: String,
                    completion: InsertUserCompletion) {
        let context = coreData.managedObjectContext
        
        let userDetails = UserDetails(context: context)
        userDetails.email = email
        userDetails.password = password
        userDetails.country = country
        
        do {
            try coreData.saveContext()
            completion(.success(true))
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
    
    func checkIfUserExists(email: String,
                           password: String,
                           completion: UserExistsCompletion) {
        let context = coreData.managedObjectContext
        let fetchRequest = UserDetails.fetchRequest()
        let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        fetchRequest.predicate = predicate
        
        do {
            let data = try context.fetch(fetchRequest)
            completion(.success(!data.isEmpty))
        } catch {
            debugPrint(error)
            completion(.failure(error))
        }
    }
    
    func checkIfUserExists(email: String, completion: EmailExistsCompletion) {
        let context = coreData.managedObjectContext
        let fetchRequest = UserDetails.fetchRequest()
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        
        do {
            let data = try context.fetch(fetchRequest)
            completion(.success(!data.isEmpty))
        } catch {
            debugPrint(error)
            completion(.failure(error))
        }
    }
}
