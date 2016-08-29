//
//  TwitterAPIManager.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Fabric
import TwitterKit



class TwitterAPIManager {
    
    //[Tweet] - result tweets array
    //Bool - true if no more tweets available
    //NSError - error in case of error
    typealias TweetsRequestCompletion = ([Tweet], Bool, NSError?)->Void
    
    //https://dev.twitter.com/rest/reference/get/statuses/home_timeline
    enum HomeTimelineParameter: String {
        case Count = "count"
        case SinceId = "since_id"
        case MaxId = "max_id"
    }
    
    
    var numberOfTweetsToRetrieve = 50
    
    
    static let sharedInstance = TwitterAPIManager()
    
    var tweetStorage: TwitterStorage?
    
    
    init() {
        tweetStorage = TwitterStorage()
    }
    
    //Helpers
    func tweetFromJson(dictionary:[String:AnyObject])->Tweet? {
        
        guard let twtrTweet = TWTRTweet(JSONDictionary: dictionary) else {
            return nil
        }
        
        guard let userId = UInt64(twtrTweet.author.userID),
            let tweetId = UInt64(twtrTweet.tweetID) else {
                return nil
        }
        
        
        let user = User(userId: userId, userName: twtrTweet.author.name, userAtName: twtrTweet.author.screenName, avatarUrl: twtrTweet.author.profileImageURL, avatarMiniUrl: twtrTweet.author.profileImageMiniURL, avatarLargeUrl: twtrTweet.author.profileImageLargeURL)
        return Tweet(tweetId: tweetId, text: twtrTweet.text, tweetDate: twtrTweet.createdAt, user: user)
    }
    
    //Log in/Log out
    var isLoggedIn: Bool {
        return Twitter.sharedInstance().sessionStore.existingUserSessions().count > 0
    }
    
    func login(completion:(Bool, NSError?)->Void) {
        Twitter.sharedInstance().logInWithMethods(TWTRLoginMethod.All) { (session, error) in
            completion(session != nil, error)
        }
    }
    
    func logOut() {
        
    }
    
    //Home timeline
    //https://dev.twitter.com/rest/reference/get/statuses/home_timeline
    func getHomeTimelineTweets(maxTweetId: UInt64?, sinceTweetId: UInt64?, completion:TweetsRequestCompletion) throws{
        
        var parameters: [NSObject : AnyObject] = [HomeTimelineParameter.Count.rawValue : "\(numberOfTweetsToRetrieve)"]
        
        if let actualSinceTweetId = sinceTweetId {
            parameters[HomeTimelineParameter.SinceId.rawValue] = "\(actualSinceTweetId)"
        }
        
        if let actualMaxTweetId = maxTweetId {
            parameters[HomeTimelineParameter.MaxId.rawValue] = "\(actualMaxTweetId - 1)"
        }
        
        try getHomeTimelineTweets(parameters, completion: completion)
    }
    
    
    private func getHomeTimelineTweets(parameters:[NSObject : AnyObject], completion:TweetsRequestCompletion) throws{
        if (!isLoggedIn) {
            return
        }
        
        var error: NSError?
        let urlRequest = TWTRAPIClient.clientWithCurrentUser().URLRequestWithMethod("GET", URL: "https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: parameters, error: &error)
        
        if let actualError = error {
            throw actualError
        }
        
        TWTRAPIClient.clientWithCurrentUser().sendTwitterRequest(urlRequest) { (urlResponse, data, error) in
            if let actualError = error {
                completion([],false, actualError)
            }else{
                guard let actualData = data else {
                    completion([], false, TwitterAPIManagerError.UnableToParseResponse.error())
                    return
                }
                
                do {
                    
                    guard let jsonArray = try NSJSONSerialization.JSONObjectWithData(actualData, options: []) as? [[String : AnyObject]] else {
                        completion([], false, TwitterAPIManagerError.UnableToParseResponse.error())
                        return
                    }
                    
                    let noMore = jsonArray.count < self.numberOfTweetsToRetrieve
                    
                    var tweetsArray:[Tweet] = []
                    
                    for dict in jsonArray {
                        if let tweet = self.tweetFromJson(dict) {
                            tweetsArray.append(tweet)
                        }
                    }
                    
                    self.tweetStorage?.addTweets(tweetsArray)
                    
                    completion(tweetsArray, noMore, nil)
                    
                }catch {
                    completion([], false, TwitterAPIManagerError.UnableToParseResponse.error())
                }
                
            }
        }
    }
}


class TwitterStorage {
    let queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
    
    private var homeTimeline: [Tweet] = []
    
    var bottomTwitterId: UInt64? {
        var resultId: UInt64?
        
        dispatch_sync(queue) {
            resultId = self.homeTimeline.last?.tweetId
        }
        
        return resultId
    }
    
    var topTwitterId: UInt64? {
        var resultId: UInt64?
        
        dispatch_sync(queue) {
            resultId = self.homeTimeline.first?.tweetId
        }
        
        return resultId
    }
    
    func addTweets(tweets:[Tweet]){
        
        //TODO: Make more sophisticated implementation
        //Check for identical tweets
        dispatch_barrier_async(queue) {
            self.homeTimeline.appendContentsOf(tweets)
            self.homeTimeline.sortInPlace { (tweet1, tweet2) -> Bool in
                return tweet1.tweetId < tweet2.tweetId
            }
        }
    }
    
    func getTweetsOlderThan(oldestTweetId: Int) -> [Tweet] {
        //TODO: implement method
        return []
    }
    
    func getTweetsYoungerThan(youngestTweetId: Int) -> [Tweet] {
        //TODO: implement method
        
        return []
    }
    
}