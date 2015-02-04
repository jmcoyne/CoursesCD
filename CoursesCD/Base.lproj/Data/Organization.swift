//
//  Organization.swift
//  CoursesCD
//
//  Created by Joan Coyne on 2/4/15.
//  Copyright (c) 2015 Mzinga. All rights reserved.
//

import Foundation
import CoreData

class Organization: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var status: String
    @NSManaged var subdomain: String
    @NSManaged var upatedAt: NSDate
    @NSManaged var hasMembership: NSSet

}
