//
//  TweetViewController.swift
//  Warble
//
//  Created by Philippe Kimura-Thollander on 2/28/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import AFNetworking

class TweetViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var isFavorited = false
    var isRetweeted = false
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = tweet.user!.name
        handleLabel.text = "@\(tweet.user!.screenname!)"
        tweetLabel.text = tweet.text
        avatarImageView.setImageWithURL(tweet.user!.profileURL!)
        retweetsLabel.text = String(tweet.retweets)
        favoritesLabel.text = String(tweet.favorites)
        timeLabel.text = tweet.timestamp
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func onFavorite(sender: AnyObject) {
        if !isFavorited {
            isFavorited = true
            sender.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
            TwitterClient.sharedInstance.favorite(tweet.id!, completion: { (complete, error) -> () in
                self.favoritesLabel.text = String((Int(self.favoritesLabel.text!)! + 1))
            })
            
        } else {
            isFavorited = false
            sender.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
            self.favoritesLabel.text = String((Int(favoritesLabel.text!)! - 1))
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !isRetweeted {
            isRetweeted = true
            sender.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Normal)
            TwitterClient.sharedInstance.retweet(tweet.id!, completion: { (complete, error) -> () in
                self.retweetsLabel.text = String((Int(self.retweetsLabel.text!)! + 1))
            })
        } else {
            isRetweeted = false
            sender.setImage(UIImage(named: "retweet-action"), forState: UIControlState.Normal)
            self.retweetsLabel.text = String((Int(self.retweetsLabel.text!)! - 1))
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "composeSegue") {
            let composeViewController = segue.destinationViewController as! ComposeViewController
            composeViewController.tweetAt = "@\(tweet.user!.screenname!)"
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        self.performSegueWithIdentifier("composeSegue", sender: sender)
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
