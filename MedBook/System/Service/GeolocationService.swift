//
//  GeolocationService.swift
//  MedBook
//
//  Created by Sanath on 09/04/24.
//

import Foundation

protocol GeolocationServiceLogic {
    typealias ResultCompletion = (Result<Geolocation, Error>) -> Void
    func fetchUserLocation(completion: @escaping ResultCompletion)
}

final class GeolocationService: GeolocationServiceLogic {
    private let networkManager: NetworkManager
    
    private let geolocationURLString = "http://ip-api.com/json"
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchUserLocation(completion: @escaping ResultCompletion) {
        guard let url = URL(string: geolocationURLString) else {
            completion(.failure(NSError(domain: "", code: 1)))
            return
        }
        
        networkManager.request(fromURL: url) { (result: Result<Geolocation, Error>) in
            switch result {
            case let .success(geolocation):
                completion(.success(geolocation))
            case let .failure(error):
                debugPrint(error)
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Network Model

struct Geolocation: Decodable {
    let countryCode: String
}
