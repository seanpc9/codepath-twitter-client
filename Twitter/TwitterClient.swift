//
//  TwitterClient.swift
//  Twitter
//
//  Created by Sean Crenshaw on 2/15/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "EcBdnFLbK1PC7Ll1lhoSrXj3k"
let twitterConsumerSecret = "ecgLpPZyfDW5vbaSty9dKFWYbyDOzzfekXZSz93F9yeF7dAaSO"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            // print("home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemoseanpc9://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion!(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                // print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error:nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("error getting current user")
                    self.loginCompletion!(user: nil, error: error)
            })
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion!(user: nil, error: error)
        }

    }
    
    func favoriteTweet(id: Int?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json?id=\(id!)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success liking")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error liking\(id!)")
        })
    }
    
    func retweetTweet(id: Int?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id!).json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success retweet")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweet\(id!)")
        })
    }
    
    func postTweet(status: String) {
        POST("1.1/statuses/update.json\(status)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("success post")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                
                print("https://api.twitter.com/1.1/statuses/update.json\(status)")
        })
    }
}
