//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/23/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profPicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tweetWordLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followingWordLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followersWordLabel: UILabel!
    
    var tweet: Tweet!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: (tweet.user?.profileImageUrl)!)
        profPicImageView.setImageWithURL(url!)
        
        nameLabel.text = tweet.user?.name
        handleLabel.text = "@" + (tweet.user?.screenname)!
        
        if let backgroundStringUrl = tweet.user?.backgroundImageUrl {
            let backgroundUrl = NSURL(string: backgroundStringUrl)
            backgroundImageView.setImageWithURL(backgroundUrl!)
        }
        
        let tweetCount = (tweet.user?.tweetCount)!
        tweetCountLabel.text = "\(tweetCount)"
        
        let followingCount = (tweet.user?.followingCount)!
        followingCountLabel.text = "\(followingCount)"
        
        let followersCount = (tweet.user?.followersCount)!
        followersCountLabel.text = "\(followersCount)"
    }
}
