//
//  CoursesCD.swift
//  CoursesCD
//
//  Created by Joan Coyne on 2/4/15.
//  Copyright (c) 2015 Mzinga. All rights reserved.
//

import Foundation
import CoreData

class CoursesCD: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var role: String
    @NSManaged var status: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var hasOrganization: CoursesCD.Organization
    @NSManaged var hasUser: CoursesCD.User

}
