//
//  Organization.swift
//  CoursesCD
//
//  Created by Joan Coyne on 1/22/15.
//  Copyright (c) 2015 Mzinga. All rights reserved.
//

import Foundation
import CoreData

@objc(Organization) class Organization: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var orgCreatedAt: NSDate
    @NSManaged var orgUpatedAt: NSDate
    @NSManaged var status: String
    @NSManaged var subdomain: String
    @NSManaged var hasMembership: NSSet

}
