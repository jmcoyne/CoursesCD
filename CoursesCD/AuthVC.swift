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
     var currentUser: User?

   
   
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
        var emailText = self.email.text
        var passwordText = self.password.text
        
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
                    let body = NSString(data: data, encoding: NSUTF8StringEncoding)
                    NSLog("Response from \(req.URL): \(body)")
                    self.authCallResults = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error) as? NSDictionary
                    NSLog("Auth Call results = %@", self.authCallResults!);
                    let successMessage = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_SUCCESS)) as? String
                    NSLog("Auth Call success = %d", successMessage!)
                    if successMessage == "z3NgdrZjqXngwrumdYi9" {
                        NSLog("We got in!")
                        self.userDidAuthenticate   = true
                        let userEmail = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_EMAIL)) as? String
                        NSLog("My email is %@", userEmail!)
                        let userFirstName = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_FIRST_NAME)) as? String
                        let userLastName = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_LAST_NAME)) as? String
                        let userId = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_ID)) as? NSNumber
                        let userAvatarURL = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_AVATAR_URL)) as? String
                        let userAuthToken = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_AUTH_TOKEN)) as? String
                        NSLog("My authToken is %@", userAuthToken!)
                        self.defaults.setObject(userEmail, forKey: "email")
                        self.defaults.setObject(userAuthToken, forKey: "authToken")
                        self.defaults.setObject(userEmail, forKey: "email")
                        self.defaults.setObject(userFirstName, forKey: "firstName")
                        self.defaults.setObject(userLastName, forKey: "lastName")
                        self.defaults.setObject(userAvatarURL, forKey: "avatarURL")
                        self.defaults.setObject(userId, forKey: "id")
                        
                        
                        //self.defaults.synchronize()
                         self.setUserProperties()
                        
                    }
                    else {
                        self.userDidAuthenticate   = false;
                    }
                    
                    // NSLog("Response:%@ %@\n", response, error);
                } else {
                    NSLog("Don't know how to handle response: \(response)")
                }
            } else {
                NSLog("Error: \(error)")
            }
        }
        
        task.resume()
    }
    func setUserProperties() {
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
              //  currentUser = user(entity: userEntity!,
                   // insertIntoManagedObjectContext: self.managedContext)
                //currentUser?.firstName = userName
               // if !managedContext.save(&error) {
               //     println("Could not save: \(error)")
               // }

            }
            else{
                println("All set")
                
            }
        }
        
        // If he's not, add him
        // self.addUser()
        //TODO Get user info, specifically, check for organizations

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
