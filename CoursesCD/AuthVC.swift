
//
//  AuthVC.swift
//  CoursesCD
//
//  Created by Joan Coyne on 1/22/15.
//  Copyright (c) 2015 Mzinga. All rights reserved.
//

import UIKit
import CoreData

 class AuthVC: UIViewController {
    
    //We will put the results of the auth call into user defaults
    var authCallResults:NSDictionary?
     var defaults: NSUserDefaults  = NSUserDefaults.standardUserDefaults()    
    
    
    
    lazy var defaultConfigObject: NSURLSessionConfiguration = {
        NSURLSessionConfiguration.defaultSessionConfiguration()
        }()
    lazy var defaultSession: NSURLSession = {
        return NSURLSession(configuration: self.defaultConfigObject)
        }()
    lazy var userDidAuthenticate:Bool = false
    // Core Data variables
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
     var currentUser: User!
   

   
   
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
   

    @IBAction func touchLogin(sender: AnyObject) {
        self.httpPostWithCustomDelegate()
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userDidAuthenticate = false
       
        
        // Do any additional setup after loading the view.
    }
    func httpPostWithCustomDelegate() { 
        // retries when connection has been terminated, avoids request if battery islowor wifi performance is not good
        defaultConfigObject.discretionary = true
        
        var defaultSession: NSURLSession = {
            NSURLSession(configuration: self.defaultConfigObject)
            }()
        if let emailText = self.email.text {
            
        }
        let passwordText = self.password.text
        
        
        let urlLogin = NSURL(string: "http://barbershoplabs.ngrok.com/api/v1/users/sign_in")!
        var req = NSMutableURLRequest(URL: urlLogin)
        
        
        
       // var reqParams:NSString = "email=\(emailText)&password=\(passwordText)&submit=true"
        var reqParams:NSString = "email=jcoyne@mzinga.com&password=barbershop&submit=true"
        NSLog("PostData: %@",reqParams)
        req.HTTPMethod = "post"
        var reqParamsData:NSData = reqParams.dataUsingEncoding(NSASCIIStringEncoding)!
        req.HTTPBody = reqParamsData
        
        NSLog("Sending request for \(req.URL)")
        var task = self.defaultSession.dataTaskWithRequest(req) {
            (data, response, error) in
            var error: NSError?
            if error == nil {
                let httpResponse = response as NSHTTPURLResponse
                NSLog("Received HTTP \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    self.userDidAuthenticate = true
                    
                    //It looks like the encoding is messing up the auth token? grab it directly
                    let authCallResults = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error) as? NSDictionary
                    if let authToken = (authCallResults?.valueForKeyPath(AUTH_RESULTS_AUTH_TOKEN)) as? String {
                         self.defaults.setObject(authToken, forKey: "authToken")
                    }
                    
                    

                    let json = JSON(data: data)
                    if let id = json["user"]["id"].numberValue {
                        // Add the id to user defaults 
                        self.defaults.setObject(id, forKey: "id")
                        self.defaults.synchronize()
                      //We got in and have an id, now check for the user
                        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: self.managedObjectContext!)
                        let user  = User(entity: userEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
                        
                        let userFetch = NSFetchRequest(entityName: "User")
                        userFetch.predicate = NSPredicate(format: "id = \(id)")
                        var error: NSError?
                        let result = self.managedObjectContext!.executeFetchRequest(userFetch, error: &error) as [User]?
                        if let users = result {
                            if users.count == 0 {
                             println(" hey I'm new")
                           self.currentUser = User(entity: userEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
                            if let userEmail = json["user"]["email"].stringValue {  self.currentUser.email = userEmail }
                                                        if let signInCount = json["user"]["sign_in_count"].numberValue { self.currentUser.signInCount = signInCount }
                            if let firstName = json["user"]["first_name"].stringValue { self.currentUser.firstName = firstName }
                            if let lastName = json["user"]["last_name"].stringValue { self.currentUser.lastName = lastName }
                            if let city = json["user"]["city"].stringValue { self.currentUser.city = city }
                            if let state = json["user"]["state"].stringValue { self.currentUser.state = state  }
                            //Thise need to be converted todates.  SKipping for now
                            //if let createdAt = json["user"]["created_at"].stringValue
                            // if let updatedAt = json["user"]["updated_at"].stringValue
                            if let imageURL = json["user"]["image"]["image"]["url"].stringValue {  self.currentUser.imageURL = imageURL }
                            if let xsmallURL = json["user"]["image"]["image"]["xsmall"]["url"].stringValue {  self.currentUser.xsmallImageURL = xsmallURL }
                            if let smallURL = json["user"]["image"]["image"]["small"]["url"].stringValue { self.currentUser.smallImageURL = smallURL }
                            if let mediumURL = json["user"]["image"]["image"]["medium"]["url"].stringValue { self.currentUser.mediumImageURL  = mediumURL }
                            if let largeURL = json["user"]["image"]["image"]["large"]["url"].stringValue { self.currentUser.largeImageURL = largeURL }
                            if !self.managedObjectContext!.save(&error) {
                                println("Could not save: \(error)")
                            }
                        } else {
                            self.currentUser = users[0]
                            println(" hey I'm a user")
                            }
                        } else {
                            println("Could not fetch: \(error)")
                        }

                    }
                    
                    
                    
                }
                    else {
                    //response not 200
                        self.userDidAuthenticate   = false;
                    }
                    
                    // NSLog("Response:%@ %@\n", response, error);
                } else {
                    NSLog("Don't know how to handle response: \(response)")
                }
            }
        
        task.resume()
           }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //IF this is the Profile button segue, pass the userId
        if segue.identifier == "Profile" {
            if let pvc = segue.destinationViewController as? ProfileVC {
                pvc.title = "Profile"
                println("Segueing to Profile")
            }
            
        }
    }


}
