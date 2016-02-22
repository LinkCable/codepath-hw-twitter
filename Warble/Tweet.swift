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
    var user: String?
    var timestamp: NSDate?
    var retweets: Int = 0
    var favorites: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweets = (dictionary["retweet_count"] as? Int) ?? 0
        favorites = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timestamp = formatter.dateFromString(timeStampString)
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
