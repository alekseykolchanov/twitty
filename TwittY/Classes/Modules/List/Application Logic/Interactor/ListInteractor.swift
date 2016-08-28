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
    
    func getTweetsBefore(beforeTweetId:UInt64?, completion:([Tweet], NSError?)->Void) {
        do {
            try twitterApiManager?.getHomeTimelineTweetsOlderThan(beforeTweetId, completion: { (tweets, error) in
                completion(tweets, error)
            })
        }catch{
            if let nserror = error as? NSError {
                completion([], nserror)
            }
            
            //TODO: Convert NSErrorType to NSError
            completion([], nil)
        }
    }
    
    func getTweetsAfter(afterTweetId:UInt64?, completion:([Tweet], NSError?)->Void) {
        do {
            try twitterApiManager?.getHomeTimelineTweetsYoungerThan(afterTweetId, completion: { (tweets, error) in
                completion(tweets, error)
            })
        }catch{
            if let nserror = error as? NSError {
                completion([], nserror)
            }
            
            //TODO: Convert NSErrorType to NSError
            completion([], nil)
        }
    }
}