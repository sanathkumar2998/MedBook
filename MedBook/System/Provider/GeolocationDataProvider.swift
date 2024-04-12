//
//  GeolocationDataProvider.swift
//  MedBook
//
//  Created by Sanath on 09/04/24.
//

import Foundation

protocol GeolocationDataProviderLogic {
    typealias ResultCompletion = (Result<Geolocation, Error>) -> Void
    func fetchUserLocation(completion: @escaping ResultCompletion)
}

final class GeolocationDataProvider: GeolocationDataProviderLogic {
    private let service: GeolocationServiceLogic
    
    init(service: GeolocationServiceLogic) {
        self.service = service
    }
    
    func fetchUserLocation(completion: @escaping ResultCompletion) {
        if let defaultCountryCode = UserDefaults.standard.fetchCountryCode() {
            let geolocation = Geolocation(countryCode: defaultCountryCode)
            completion(.success(geolocation))
        } else {
            service.fetchUserLocation { result in
                switch result {
                case let .success(geolocation):
                    UserDefaults.standard.saveCountryCode(countryCode: geolocation.countryCode)
                    completion(.success(geolocation))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
