//
//  TwitterClient.swift
//  Warble
//
//  Created by Philippe Kimura-Thollander on 2/21/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance =  TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "FaAWQm1oSx7urVRMOyVJzAD9f", consumerSecret: "ZO17rF3h6hhyjb7TX6aWwM7TtVgC5o9bi19OW6UgDE39W3jAUO")
    
    func currentAccount() {
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {
                (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                print(user)
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {
                (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsFromArray(dictionaries)
                success(tweets)
            
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
}
