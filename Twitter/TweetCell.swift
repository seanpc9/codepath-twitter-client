//
//  TweetCell.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/16/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetLabel.text = tweet.text
            tweetLabel.sizeToFit()
            let url = NSURL(string: (tweet.user?.profileImageUrl)!)
            profileImageView.setImageWithURL(url!)
            nameLabel.text = tweet.user?.name
            handleLabel.text = "@" + (tweet.user?.screenname)!
            timestampLabel.text = tweet.timestamp
            retweetLabel.text = String(tweet.retweetCount!)
            likeLabel.text = String(tweet.favoriteCount!)
            retweetLabel.sizeToFit()
            likeLabel.sizeToFit()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetTweet(tweet.id) { (tweets, error) -> () in
            
        }
        retweetLabel.text = String(Int(tweet.retweetCount!) + 1)
        retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Normal)
    }
    
    @IBAction func onLike(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteTweet(tweet.id) { (tweets, error) -> () in
            
        }
        likeLabel.text = String(Int(tweet.favoriteCount!) + 1)
        likeButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
    }
    
}
