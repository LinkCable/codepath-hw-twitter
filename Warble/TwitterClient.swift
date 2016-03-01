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
    
    //completion to check if log in successfully or not
    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    static let sharedInstance =  TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "FaAWQm1oSx7urVRMOyVJzAD9f", consumerSecret: "ZO17rF3h6hhyjb7TX6aWwM7TtVgC5o9bi19OW6UgDE39W3jAUO")
    
    func currentAccount() {
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {
                (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                print(user)
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                
        })
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
            let tweets = Tweet.tweetsFromArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: {(operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Error: \(error.localizedDescription)")
                completion(tweets: nil, error: error)
        })
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: {(accessToken: BDBOAuth1Credential!) -> Void in
            print("got the access token!")
            
            // gets access token, account credentials, then gets current user
            self.requestSerializer.saveAccessToken(accessToken)
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: {(operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                
                self.loginCompletion?(user: user, error: nil)
                }, failure: {(operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            }) {
                (error: NSError!) -> Void in
                print("failed to receive access token")
        }
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "warble://oauth"), scope: nil, success: {
                (requestToken: BDBOAuth1Credential!) -> Void in
            
                // let twitter know we're authorized to send user here
                let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            
            }) {
                (error: NSError!) -> Void in
                print("Error: \(error.localizedDescription)")
                // if failure, call login completion and give it a nil user and an error
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func favorite(tweetID: String, completion: (complete: Bool?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json?id=\(tweetID)", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(complete: true, error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Unable to favorite")
                completion(complete: false, error: error)
        }
    }
    
    func retweet(tweetID: String, completion: (complete: Bool?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(tweetID).json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(complete: true, error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Unable to retweet")
                completion(complete: false, error: error)
        }
    }
    
    func user_info(user_id: String, completion: (user: User?, error: NSError?) -> ()) {
        GET("1.1/users/show.json?user_id=\(user_id)", parameters: nil, success: {
            (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            completion(user: user, error: nil)
            
            }, failure: {(operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting profile user")
        })

    }
    
    func user_tweets(user_id: String, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/user_timeline.json?user_id=\(user_id)", parameters: nil, success: {
            (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsFromArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: {(operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting list of tweets for user")
        })
        
        
    }

    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
    }
    
}
