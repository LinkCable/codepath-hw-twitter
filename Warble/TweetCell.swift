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

    var tweet: Tweet!{
        didSet{
            fullNameLabel.text = tweet.user!.name
            handleLabel.text = "@\(tweet.user!.screenname!)"
            tweetLabel.text = tweet.text
            avatarImageView.setImageWithURL(tweet.user!.profileURL!)
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

}
