//
//  User.swift
//  Warble
//
//  Created by Philippe Kimura-Thollander on 2/21/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileURL: NSURL?
    var tagline: String?
    var id: String?
    var backgroundURL: NSURL?
    var followers_count: Int?
    var following_count: Int?
    var status_count: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        id = dictionary["id_str"] as? String
        followers_count = dictionary["followers_count"] as? Int
        status_count = dictionary["statuses_count"] as? Int
        following_count = dictionary["friends_count"] as? Int
        
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = NSURL(string: profileURLString)
        }
        
        tagline = dictionary["description"] as? String
        
        let backgroundURLString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundURLString = backgroundURLString {
            backgroundURL = NSURL(string: backgroundURLString)
        }
        
        
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
        
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: [])
        
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
        
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    func logout() {
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    }
}
