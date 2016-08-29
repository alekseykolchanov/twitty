//
//  ListInteractor.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 28/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation

class ListInteractor {
    
    var twitterApiManager: TwitterAPIManager?
    
    func getHomeTweets(maxTweetId: UInt64?, sinceTweetId: UInt64?, completion:([Tweet], Bool, NSError?)->Void) {
        do {
            try twitterApiManager?.getHomeTimelineTweets(maxTweetId, sinceTweetId: sinceTweetId, completion: { (tweets, noMore, error) in
                completion(tweets, noMore, error)
            })
        }catch{
            if let nserror = error as? NSError {
                completion([], false, nserror)
            }
            
            //TODO: Convert NSErrorType to NSError
            completion([], false, nil)
        }
    }
    
}