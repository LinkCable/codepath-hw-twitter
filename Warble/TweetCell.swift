//
//  TweetCell.swift
//  Warble
//
//  Created by Philippe Kimura-Thollander on 2/23/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    var isFavorited = false
    var isRetweeted = false
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!

    var tweet: Tweet!{
        didSet{
            fullNameLabel.text = tweet.user!.name
            handleLabel.text = "@\(tweet.user!.screenname!)"
            tweetLabel.text = tweet.text
            avatarImageView.setImageWithURL(tweet.user!.profileURL!)
            retweetsLabel.text = String(tweet.retweets)
            favoritesLabel.text = String(tweet.favorites)
            timestampLabel.text = tweet.timestamp
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favoriteClick(sender: AnyObject) {
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
    
    @IBAction func retweetClick(sender: AnyObject) {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
    }

}
