//
//  Membership.swift
//  CoursesCD
//
//  Created by Joan Coyne on 1/22/15.
//  Copyright (c) 2015 Mzinga. All rights reserved.
//

import Foundation
import CoreData

@objc(Membership) class Membership: NSManagedObject {

    @NSManaged var membershipCreatedAt: NSDate
    @NSManaged var membershipUpdatedAt: NSDate
    @NSManaged var role: String
    @NSManaged var status: String
    @NSManaged var hasOrganization: NSManagedObject
    @NSManaged var hasUser: NSManagedObject

}
