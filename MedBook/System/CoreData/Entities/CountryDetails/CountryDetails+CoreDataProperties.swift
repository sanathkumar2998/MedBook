//
//  CountryDetails+CoreDataProperties.swift
//  MedBook
//
//  Created by Sanath on 11/04/24.
//
//

import Foundation
import CoreData


public extension CountryDetails {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CountryDetails> {
        return NSFetchRequest<CountryDetails>(entityName: "CountryDetails")
    }

    @NSManaged var name: String?
    @NSManaged var countryCode: String?

}

