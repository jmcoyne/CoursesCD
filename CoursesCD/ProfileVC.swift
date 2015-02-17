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

    
    override func viewWillAppear(animated: Bool) {
         self.httpGetWithCustomDelegate()
    }
    
    
    
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
          
          
        }
    
    }
    func httpGetWithCustomDelegate() {
        // retries when connection has been terminated, avoids request if battery islowor wifi performance is not good
        defaultConfigObject.discretionary = true
        
        var defaultSession: NSURLSession = {
            NSURLSession(configuration: self.defaultConfigObject)
            }()
       
        
        
        let urlGetUser = NSURL(string: "http://barbershoplabs.ngrok.com/api/v1/users/4?authentication_token=z3NgdrZjqXngwrumdYi9")!
        var req = NSMutableURLRequest(URL: urlGetUser)
        
        
        
        // var reqParams:NSString = "email=\(emailText)&password=\(passwordText)&submit=true"
        //var reqParams:NSString = "email=jcoyne@mzinga.com&password=barbershop&authentication_token=z3NgdrZjqXngwrumdYi9"
        //NSLog("PostData: %@",reqParams)
        req.HTTPMethod = "GET"
        //var reqParamsData:NSData = reqParams.dataUsingEncoding(NSASCIIStringEncoding)!
        //req.HTTPBody = reqParamsData
        
        NSLog("Sending request for \(req.URL)")
        var task = self.defaultSession.dataTaskWithRequest(req) {
            (data, response, error) in
            var error: NSError?
            if error == nil {
                let httpResponse = response as NSHTTPURLResponse
                NSLog("Received HTTP \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    let  json = JSON(data:  data)
                    
                        let id: String? = json["user"]["id"].stringValue
                        let userEmail: String? = json["user"]["email"].stringValue
                        let signInCount: String? = json["user"]["sign_in_count"].stringValue
                        let firstName: String? = json["user"]["first_name"].stringValue
                        let lastName: String? = json["user"]["last_name"].stringValue
                        let city: String? = json["user"]["city"].stringValue
                        let state: String? = json["user"]["state"].stringValue
                        let createdAt: String? = json["user"]["created_at"].stringValue
                        let updatedAt: String? = json["user"]["updated_at"].stringValue
                        let imageURL: String? = json["user"]["image"]["image"]["url"].stringValue
                        let xsmallURL: String? = json["user"]["image"]["image"]["xsmall"]["url"].stringValue
                        let smallURL: String? = json["user"]["image"]["image"]["small"]["url"].stringValue
                        let mediumURL: String? = json["user"]["image"]["image"]["medium"]["url"].stringValue
                        let largeURL: String? = json["user"]["image"]["image"]["large"]["url"].stringValue
                    if let membershipArray = json["user"]["memberships"].arrayValue {
                        //2
                        
                        
                        //3
                        for membershipDict in membershipArray {
                            var membershipStatus: String? = membershipDict["status"].stringValue
                            var membershipRole: String? = membershipDict["role"].stringValue
                            var membershipCreatedAt: String? = membershipDict["created_at"].stringValue
                            var membershipUpdatedAt: String? = membershipDict["updated_at"].stringValue
                            var orgName: String? = membershipDict["organization"]["name"].stringValue
                            var orgId: String? = membershipDict["organization"]["id"].stringValue
                            var orgSubdomain: String? = membershipDict["organization"]["subdomain"].stringValue
                            var orgStatus: String? = membershipDict["organization"]["status"].stringValue
                            var orgCreatedAt: String? = membershipDict["organization"]["created_at"].stringValue
                            var orgUpdatedAt: String? = membershipDict["organization"]["updated_at"].stringValue
                            
                          //  var org = Organization(id: orgId!, name: orgName!, subdomain: orgSubdomain!, status: orgStatus!, createdAt: orgCreatedAt!, updatedAt: orgUpdatedAt!)
                         //   self.organizations.append(org)
                          //  let membership = Membership(status: membershipStatus, role: membershipRole, createdAt: membershipCreatedAt, updatedAt: membershipUpdatedAt, organization: org);
                            
                        }
                        
                        
                        
                        
                        
                    }
                 
                   self.city.text = city
                    self.state.text = state
                    
                    
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
