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
            
            //TODO add API call to get all user data
            
            //city.text = defaults.stringForKey("city")
            // state.text = defaults.stringForKey("state")
        }
    
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
