//
//  CountriesService.swift
//  MedBook
//
//  Created by Sanath on 09/04/24.
//

import Foundation

protocol CountriesServiceLogic {
    typealias ActionCompletion = (Result<CountryData, Error>) -> Void
    func fetchCountries(completion: @escaping ActionCompletion)
}

final class CountriesService: CountriesServiceLogic  {
    private let networkManager: NetworkManager
    
    private let countriesListURLString = "https://api.first.org/data/v1/countries"
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchCountries(completion: @escaping ActionCompletion) {
        guard let url = URL(string: countriesListURLString) else {
            completion(.failure(NSError(domain: "", code: 1)))
            return
        }
        
        networkManager.request(fromURL: url) { (result: Result<CountryData, Error>) in
            switch result {
            case let .success(countries):
                completion(.success(countries))
            case let .failure(error):
                debugPrint(error)
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Network Model

struct CountryData: Decodable {
    let data: [String: Country]
}

struct Country: Decodable {
    let country: String
    let region: String
}
