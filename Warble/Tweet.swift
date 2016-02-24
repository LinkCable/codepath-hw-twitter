//
//  Tweet.swift
//  Warble
//
//  Created by Philippe Kimura-Thollander on 2/21/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var user: User?
    var time: NSDate?
    var timePassed: Int?
    var timestamp: String?
    var retweets: Int = 0
    var favorites: Int = 0
    var id: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        retweets = (dictionary["retweet_count"] as? Int) ?? 0
        favorites = (dictionary["favourites_count"] as? Int) ?? 0
        id = (dictionary["id_str"]) as? String
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            time = formatter.dateFromString(timeStampString)
            
            let now = NSDate()
            let then = time
            timePassed = Int(now.timeIntervalSinceDate(then!))
            
            // creds for this function go to @dylan-james-smith from ccsf
            if timePassed >= 86400 {
                timestamp = String(timePassed! / 86400)+"d"
            }
            if (3600..<86400).contains(timePassed!) {
                timestamp = String(timePassed!/3600)+"h"
            }
            if (60..<3600).contains(timePassed!) {
                timestamp = String(timePassed!/60)+"m"
            }
            if timePassed < 60 {
                timestamp = String(timePassed!)+"s"
            }
        }
        
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
    
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
    
        return tweets
    }
    
}
