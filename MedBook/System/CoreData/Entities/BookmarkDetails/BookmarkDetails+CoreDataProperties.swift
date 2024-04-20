//
//  BookmarkDetails+CoreDataProperties.swift
//  MedBook
//
//  Created by Sanath on 19/04/24.
//
//

import Foundation
import CoreData


extension BookmarkDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkDetails> {
        return NSFetchRequest<BookmarkDetails>(entityName: "BookmarkDetails")
    }

    @NSManaged public var key: String?
    @NSManaged public var title: String?
    @NSManaged public var ratingsAverage: Float
    @NSManaged public var ratingsCount: Int64
    @NSManaged public var authorName: String?
    @NSManaged public var coverI: Int64

}

extension BookmarkDetails : Identifiable {
    
}

extension BookmarkDetails {
    func encode(_ model: BookDetails) {
        key = model.key
        title = model.title
        ratingsAverage = model.ratingsAverage ?? 0.0
        ratingsCount = Int64(model.ratingsCount ?? 0)
        authorName = model.authorName?.first
        coverI = Int64(model.coverI ?? 0)
    }
}
