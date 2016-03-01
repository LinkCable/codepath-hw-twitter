//
//  ComposeViewController.swift
//  Warble
//
//  Created by Philippe Kimura-Thollander on 2/29/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.setImageWithURL((User._currentUser?.profileURL)!)
        nameLabel.text = User._currentUser?.name
        handleLabel.text = User._currentUser?.screenname
        
        self.tweetTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        let urlSafeString = tweetTextField.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        TwitterClient.sharedInstance.tweet(urlSafeString!, completion: { (complete, error) -> () in
            if complete == true {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else {
                print("Unable to tweet")
            }
        })

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
