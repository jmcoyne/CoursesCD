//
//  ParseUser.swift
//  CoursesCD
//
//  Created by Joan Coyne on 2/11/15.
//  Copyright (c) 2015 Mzinga. All rights reserved.
//

import Foundation
import UIKit



class ParseUser {
    
    private let id: String
    private let email: String
    private let imageURL: String
    private let xsmallURL: String
    private let smallURL: String
    private let mediumURL: String
    private let largeURL: String
    private let firstName: String
    private let lastName: String
    private let city: String
    private let state: String
    private let createdAt: String
    private let updatedAt: String
    

    
    init(userJSON: NSData) {
        let json = JSON(data: userJSON)
        var id: String? = json["user"]["id"].stringValue
        var userEmail: String? = json["user"]["email"].stringValue
        var signInCount: String? = json["user"]["sign_in_count"].stringValue
        var firstName: String? = json["user"]["first_name"].stringValue
        var lastName: String? = json["user"]["last_name"].stringValue
        var city: String? = json["user"]["city"].stringValue
        var state: String? = json["user"]["state"].stringValue
        var createdAt: String? = json["user"]["created_at"].stringValue
        var updatedAt: String? = json["user"]["updated_at"].stringValue
        var imageURL: String? = json["user"]["image"]["image"]["url"].stringValue
        var xsmallURL: String? = json["user"]["image"]["image"]["xsmall"]["url"].stringValue
        var smallURL: String? = json["user"]["image"]["image"]["small"]["url"].stringValue
        var mediumURL: String? = json["user"]["image"]["image"]["medium"]["url"].stringValue
        var largeURL: String? = json["user"]["image"]["image"]["large"]["url"].stringValue
        

        self.id = id
        self.email = email
        self.imageURL = imageURL ?? ""
        self.xsmallURL = xsmallURL ?? ""
        self.smallURL = smallURL ?? ""
        self.mediumURL = mediumURL ?? ""
        self.largeURL = largeURL ?? ""
        self.firstName = firstName ?? ""
        self.lastName  = lastName ?? ""
        self.city = city ?? ""
        self.state  = state ?? ""
        self.createdAt = createdAt!
        self.updatedAt = updatedAt!
       
        
        
    }
    func addUser() {
        //
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: self.managedObjectContext!)
        let user = User(entity: userEntity!, insertIntoManagedObjectContext:self.managedObjectContext!)
        // Check to see if user is in D
        let userId:Int = self.defaults.stringForKey("id")!.toInt()!
        let userFetch = NSFetchRequest(entityName: "User")
        
        userFetch.predicate = NSPredicate(format: "id == %d", userId)
        var fetchError: NSError?
        // let result = self.managedObjectContext.executeFetchRequest(userFetch, error: &fetchError ) as [User]?
        let result = self.managedObjectContext?.executeFetchRequest(userFetch, error: &fetchError)  as [User]?
        if let users = result {
            if users.count == 0 {
                println("No user here!")
                currentUser = User(entity: userEntity!,
                    insertIntoManagedObjectContext: self.managedObjectContext)
                currentUser?.firstName = self.defaults.stringForKey("firstName")!
                currentUser?.lastName = self.defaults.stringForKey("lastName")!
                currentUser?.id = self.defaults.stringForKey("id")!.toInt()!
                if self.managedObjectContext?.save(&fetchError) != nil {
                    println("Could not save: ")
                }
                
            }
            else{
                println("All set")
                
            }
        }
        
        
    }

}

