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
                    let json = JSON(data: data)
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
                    var largeURL: String? = json["user"]["image"]["image"]["large"]["url"].stringValue               }
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
