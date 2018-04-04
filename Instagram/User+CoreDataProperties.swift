//
//  User+CoreDataProperties.swift
//  Instagram
//
//  Created by Kirti Parghi on 3/27/18.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var emailid: String?
    @NSManaged public var password: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var photos: NSSet?
}

// MARK: Generated accessors for photos
extension User {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photos)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photos)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
}
