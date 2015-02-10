//
//  ProfileVC.swift
//  CoursesCD
//
//  Created by Joan Coyne on 2/4/15.
//  Copyright (c) 2015 Mzinga. All rights reserved.
//

import UIKit

@objc(ProfileVC) class ProfileVC: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var email: UITextField!
   
   
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    
     var authCallResults:NSDictionary?
    lazy var defaultConfigObject: NSURLSessionConfiguration = {
        NSURLSessionConfiguration.defaultSessionConfiguration()
        }()
    lazy var defaultSession: NSURLSession = {
        return NSURLSession(configuration: self.defaultConfigObject)
        }()

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        if let id = defaults.stringForKey("id")
        {
            println(id)
            firstName.text = defaults.stringForKey("firstName")
            lastName.text = defaults.stringForKey("lastName")
            email.text = defaults.stringForKey("email")
            let authCode = defaults.stringForKey("authToken")!
            
            //TODO add API call to get all user data
            
            //FOr now, lets force the auth 
         
            
            //city.text = defaults.stringForKey("city")
            // state.text = defaults.stringForKey("state")
            self.httpPostWithCustomDelegate()
        }
    
    }
    func httpPostWithCustomDelegate() {
        // retries when connection has been terminated, avoids request if battery islowor wifi performance is not good
        defaultConfigObject.discretionary = true
        
        var defaultSession: NSURLSession = {
            NSURLSession(configuration: self.defaultConfigObject)
            }()
        if let emailText = self.email.text {
            
        }
        let passwordText = "barbershop"
        
        
        let urlLogin = NSURL(string: "http://barbershoplabs.ngrok.com/api/v1/users/4")!
        var req = NSMutableURLRequest(URL: urlLogin)
        
        
        
        // var reqParams:NSString = "email=\(emailText)&password=\(passwordText)&submit=true"
        var reqParams:NSString = "email=jcoyne@mzinga.com&password=barbershop&authentication_token=z3NgdrZjqXngwrumdYi9"
        NSLog("PostData: %@",reqParams)
        req.HTTPMethod = "GET"
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
                        
                       
                        let userEmail = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_EMAIL)) as? String
                        NSLog("My email is %@", userEmail!)
                        let userFirstName = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_FIRST_NAME)) as? String
                        let userLastName = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_LAST_NAME)) as? String
                        let userId = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_ID)) as? NSNumber
                        let userAvatarURL = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_AVATAR_URL)) as? String
                        let userAuthToken = (self.authCallResults?.valueForKeyPath(AUTH_RESULTS_AUTH_TOKEN)) as? String
                        NSLog("My authToken is %@", userAuthToken!)
                        
                        
                       
                        
                    }
                    else {
                       println("Oops")
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
