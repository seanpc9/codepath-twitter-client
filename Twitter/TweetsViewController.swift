//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/15/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.selectionStyle = .None
        cell.tweet = tweets![indexPath.row]
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var tweet: Tweet
        
        if segue.identifier == "TweetToDetails"
        {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            tweet = tweets![(indexPath?.row)!]
            
            let detailsViewController = segue.destinationViewController as! TweetDetailsViewController
            detailsViewController.tweet = tweet
        }
        
        if segue.identifier == "ImageToProfile"
        {
            let profPic = sender as! UIButton
            let cell = profPic.superview!.superview as! UITableViewCell
            
            let indexPath = tableView.indexPathForCell(cell)
            tweet = tweets![(indexPath?.row)!]
            
            let profileViewController = segue.destinationViewController as? ProfileViewController
            profileViewController!.tweet = tweet
        }
    }
}
