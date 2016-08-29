//
//  ListPresenter.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class ListPresenter: ListModuleInterface, TableViewDataSourceProtocol {
    
    var listWireframe: ListWireframe?
    var listInteractor: ListInteractor?
    var userInterface: ListViewInterface?
    
    var tweets:[Tweet] = []
    
    
    init() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: UIApplication.sharedApplication(), queue: NSOperationQueue.mainQueue()) { (_) in
            //TODO: clean
        }
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func addTweets(tweetsToAdd:[Tweet]) {
        
        if tweetsToAdd.count == 0 {
            return
        }
        
        
        if tweets.last == nil || tweets.last!.tweetId > tweetsToAdd.first!.tweetId {
            
            //Case when either tweets array is empty or tweetsToAdd array should be appended to the end of tweets array
            
            tweets.appendContentsOf(tweetsToAdd)
            userInterface?.addItemsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(tweets.count - tweetsToAdd.count, tweetsToAdd.count)))
        }else{
            
            //Tweets array is not empty
            
            //TODO: Need to be more safe with index to insert. Default value 0 is not really good idea
            var indexToInsert:Int = 0
            
            for (ind,tweet) in tweets.enumerate() {
                if tweet.tweetId < tweetsToAdd.last!.tweetId {
                    indexToInsert = ind
                    break
                }
            }
            
            tweets.insertContentsOf(tweetsToAdd, at: indexToInsert)
            userInterface?.addItemsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(indexToInsert, tweetsToAdd.count)))
        }
    }
    
    //ListModuleInterface
    func settingsAction() {
        
    }
    
    func searchAction() {
        
    }
    
    func selectTweetAction(tweet:Tweet) {
        listWireframe?.showDetailInterface(tweet)
    }
    
    func updateViewOnAppear() {
        self.listInteractor?.getHomeTweets(nil, sinceTweetId: self.tweets.first?.tweetId, completion: { (recievedTweets, noMore, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if (error == nil) {
                    if !noMore {
                        self.tweets = []
                        self.userInterface?.reloadItems()
                    }
                    self.addTweets(recievedTweets)
                }
            })
        })
        
    }
    
    func refreshOnTop() {
        self.listInteractor?.getHomeTweets(nil, sinceTweetId: self.tweets.first?.tweetId, completion: { (recievedTweets, noMore, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if (error == nil) {
                    if !noMore {
                        self.tweets = []
                        self.userInterface?.reloadItems()
                    }
                    self.addTweets(recievedTweets)
                }
                
                self.userInterface?.hideDownloadAtTop()
            })
        })
    }
    
    //tableView data source
    func numberOfItems() -> Int {
        return tweets.count
    }
    
    func itemAtIndex(ind:Int)->Any {
        
        if (ind == tweets.count - 1) {
            userInterface?.showDownloadAtBottom()
            listInteractor?.getHomeTweets(tweets.last!.tweetId, sinceTweetId: nil, completion: { (recievedTweets, noMore, error) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if (error == nil) {
                        if (noMore) {
                            self.userInterface?.hideDownloadAtBottom()
                        }
                        self.addTweets(recievedTweets)
                    }
                })
            })
        }
        
        return tweets[ind]
    }
}