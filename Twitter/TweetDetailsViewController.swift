//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/23/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var profImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetWordLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteWordLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    var user: User!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: (tweet.user?.profileImageUrl)!)
        profImageView.setImageWithURL(url!)
        
        nameLabel.text = tweet.user?.name
        handleLabel.text = "@" + (tweet.user?.screenname)!
        retweetCountLabel.text = String(tweet.retweetCount!)
        favoriteCountLabel.text = String(tweet.favoriteCount!)
        tweetLabel.text = tweet.text
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetTweet(tweet.id) { (tweets, error) -> () in
            
        }
        retweetCountLabel.text = String(Int(tweet.retweetCount!) + 1)
        retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Normal)
    }
    
    @IBAction func onLike(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteTweet(tweet.id) { (tweets, error) -> () in
            
        }
        favoriteCountLabel.text = String(Int(tweet.favoriteCount!) + 1)
        favoriteButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ReplyToCompose"
        {
            let replyID = tweet.id
            let vc = segue.destinationViewController as! ComposeViewController
            vc.replyID = replyID
        }
    }
    
}
