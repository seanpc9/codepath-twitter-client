//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/23/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetSizeLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var replyID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        
        nameLabel.text = User.currentUser?.name
        handleLabel.text = User.currentUser?.screenname
        let url = NSURL(string: (User.currentUser?.profileImageUrl)!)
        profImageView.setImageWithURL(url!)
        tweetSizeLabel.text = "\(140)"
    }
    
    @IBAction func endTweet(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        
        var post =  "?status=" + tweetTextView.text!.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if (replyID != nil) {
            post += "&in_reply_to_status_id=\(replyID!)"
        }
        
        TwitterClient.sharedInstance.postTweet(post)
        
        performSegueWithIdentifier("TweetToHome", sender: self)
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let charCount = Int(textView.text.characters.count)
        
        tweetSizeLabel.text = "\(140 - charCount)"
    }
}
