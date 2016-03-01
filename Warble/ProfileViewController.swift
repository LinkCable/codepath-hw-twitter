//
//  ProfileViewController.swift
//  Warble
//
//  Created by Philippe Kimura-Thollander on 2/29/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 108
        tableView.rowHeight = UITableViewAutomaticDimension
        
        nameLabel.text = user.name
        handleLabel.text = user.screenname
        tweetsLabel.text = String(user.status_count!)
        followersLabel.text = String(user.followers_count!)
        followingLabel.text = String(user.following_count!)
        
        avatarImageView.setImageWithURL(user.profileURL!)
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.clipsToBounds = true
        
        backgroundImageView.setImageWithURL(user.backgroundURL!)
        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurView)
        
        
        TwitterClient.sharedInstance.user_tweets(user.id!, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
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

    @IBAction func onCompose(sender: AnyObject) {
        self.performSegueWithIdentifier("composeSegue", sender: sender)
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
