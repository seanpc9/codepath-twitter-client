//
//  Tweet.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/15/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timestamp: String?
    var retweetCount: NSNumber?
    var favoriteCount: NSNumber?
    var id: Int?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = dictionary["retweet_count"] as? NSNumber
        favoriteCount = dictionary["favorite_count"] as? NSNumber
        id = dictionary["id"] as? Int
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        let now = NSDate()
        let then = createdAt
        let timeSince = Int(now.timeIntervalSinceDate(then!))
        
        if timeSince >= 86400 {
            timestamp = String(timeSince / 86400)+"d"
        }
        if (3600..<86400).contains(timeSince) {
            timestamp = String(timeSince/3600)+"h"
        }
        if (60..<3600).contains(timeSince) {
            timestamp = String(timeSince/60)+"m"
        }
        if timeSince < 60 {
            timestamp = String(timeSince)+"s"
        }

    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
