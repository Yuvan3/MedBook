//
//  User+CoreDataProperties.swift
//  MedBook
//
//  Created by Yuvan Shankar on 08/08/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var country: String?

}

extension User : Identifiable {

}
