//
//  CountryDetailsDataStore.swift
//  MedBook
//
//  Created by Sanath on 11/04/24.
//

import Foundation
import CoreData

protocol CountryDetailsDataStoreLogic {
    typealias InsertCountryCompletion = (Result<Bool, Error>) -> Void
    func insertCountries(countries: CountryData, completion: InsertCountryCompletion)
    
    typealias FetchFromLocalCompletion = (Result<[CountryDetails], Error>) -> Void
    func fetchFromLocal(completion: FetchFromLocalCompletion)
}

final class CountryDetailsDataStore {
    let coreData: CoreDataProtocol
    
    init(coreData: CoreDataProtocol) {
        self.coreData = coreData
    }
}

// MARK: - CountryDetailsDataStoreLogic

extension CountryDetailsDataStore: CountryDetailsDataStoreLogic {
    func fetchFromLocal(completion: (Result<[CountryDetails], Error>) -> Void) {
        let context = coreData.managedObjectContext
        
        let fetchRequest = CountryDetails.fetchRequest()
        
        do {
            let data = try context.fetch(fetchRequest)
            completion(.success(data))
        } catch {
            debugPrint(error)
            completion(.failure(error))
        }
    }
    
    func insertCountries(countries: CountryData, completion: InsertCountryCompletion) {
        let context = coreData.managedObjectContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: CountryDetails.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error {
            debugPrint(error)
        }
        
        for item in countries.data {
            let countryDetails = CountryDetails(context: context)
            countryDetails.name = item.value.country
            countryDetails.countryCode = item.key
        }
        
        do {
            try coreData.saveContext()
            completion(.success(true))
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
}
