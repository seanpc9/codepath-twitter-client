//
//  Tweet.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/15/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    let user: User?
    let text: String?
    let createdAtString: String?
    let createdAt: NSDate?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
