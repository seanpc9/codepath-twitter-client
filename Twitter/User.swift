//
//  User.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/15/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    var backgroundImageUrl: String?
    var tweetCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        backgroundImageUrl = dictionary["profile_banner_url"] as? String
        tweetCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
        if let background = dictionary["profile_banner_url"] as? String
        {
            backgroundImageUrl = background
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                //logged out or just boot up
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    let dictionary: NSDictionary?
                    do {
                        try dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        _currentUser = User(dictionary: dictionary!)
                    } catch {
                        print(error)
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            //User need to implement NSCoding; but, JSON also serialized by default
            if let _ = _currentUser {
                var data: NSData?
                do {
                    try data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print(error)
                }
            }
        }
    }
}
