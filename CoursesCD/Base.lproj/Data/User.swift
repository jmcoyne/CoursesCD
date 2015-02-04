//
//  User.swift
//  CoursesCD
//
//  Created by Joan Coyne on 2/4/15.
//  Copyright (c) 2015 Mzinga. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var avatar: NSData
    @NSManaged var city: String
    @NSManaged var createAt: NSDate
    @NSManaged var email: String
    @NSManaged var firstName: String
    @NSManaged var id: NSNumber
    @NSManaged var imageURL: String
    @NSManaged var largeImageURL: String
    @NSManaged var lastName: String
    @NSManaged var mediumImageURL: String
    @NSManaged var signInCount: NSNumber
    @NSManaged var smallImageURL: String
    @NSManaged var state: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var xsmallImageURL: String
    @NSManaged var hasMembership: NSSet

}
