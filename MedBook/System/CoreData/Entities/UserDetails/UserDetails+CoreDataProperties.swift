//
//  UserDetails+CoreDataProperties.swift
//  MedBook
//
//  Created by Sanath on 11/04/24.
//
//

import Foundation
import CoreData

public extension UserDetails {

    @nonobjc
    class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged var email: String?
    @NSManaged var password: String?
    @NSManaged var country: String?

}
