//
//  TweetsViewController.swift
//  Warble
//
//  Created by Philippe Kimura-Thollander on 2/23/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 108
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.selectionStyle = .None
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TweetCell
        let selectedTweet = cell.tweet
        self.performSegueWithIdentifier("tweetSegue", sender: selectedTweet)
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "tweetSegue") {
            let secondViewController = segue.destinationViewController as! TweetViewController
            let selectedTweet = sender as! Tweet
            secondViewController.tweet = selectedTweet
        }
        
        if (segue.identifier == "profileSegue") {
            
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = tweet.user
        }
        
        if (segue.identifier == "meSegue") {
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = User._currentUser
        }
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    
    @IBAction func onProfileTap(sender: AnyObject) {
        performSegueWithIdentifier("profileSegue", sender: sender)
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        performSegueWithIdentifier("composeSegue", sender: sender)
    }
    @IBAction func onMe(sender: AnyObject) {
        performSegueWithIdentifier("meSegue", sender: sender)
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
