//
//  CountriesDataProvider.swift
//  MedBook
//
//  Created by Sanath on 09/04/24.
//

import Foundation

protocol CountriesDataProviderLogic {
    typealias ActionCompletion = (Result<CountryData, Error>) -> Void
    func fetchCountries(completion: @escaping ActionCompletion)
}

final class CountriesDataProvider: CountriesDataProviderLogic {
    private let service: CountriesServiceLogic
    private let countryDetailsDataStore: CountryDetailsDataStoreLogic
    
    init(service: CountriesServiceLogic,
         countryDetailsDataStore: CountryDetailsDataStoreLogic) {
        self.service = service
        self.countryDetailsDataStore = countryDetailsDataStore
    }
    
    func fetchCountries(completion: @escaping ActionCompletion) {
        countryDetailsDataStore.fetchFromLocal { result in
            switch result {
            case let .success(countryDetails):
                if !countryDetails.isEmpty {
                    var data: [String: Country] = [:]
                    for item in countryDetails {
                        if let countryCode = item.countryCode,
                           let name = item.name {
                            data[countryCode] = Country(country: name,
                                                        region: "")
                        }
                        
                    }
                    let countryData = CountryData(data: data)
                    completion(.success(countryData))
                } else {
                    fetchFromRemote(completion: completion)
                }
            case let .failure(error):
                debugPrint(error)
                completion(.failure(error))
            }
        }
    }
    
    func handleSuccess(countryData: CountryData, completion: @escaping ActionCompletion) {
        countryDetailsDataStore.insertCountries(countries: countryData) { result in
            completion(.success(countryData))
        }
    }
    
    func fetchFromRemote(completion: @escaping ActionCompletion) {
        service.fetchCountries { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(countryData):
                self.handleSuccess(countryData: countryData, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
