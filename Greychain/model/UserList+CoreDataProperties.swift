//
//  UserList+CoreDataProperties.swift
//  Greychain
//
//  Created by Mujahid on 23/09/20.
//  Copyright © 2020 Individual. All rights reserved.
//
//

import Foundation
import CoreData


extension UserList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserList> {
        return NSFetchRequest<UserList>(entityName: "UserList")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var dob: String?
    @NSManaged public var image: Data?

}
