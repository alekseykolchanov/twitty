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
    
    var tweetsEntities:[ListViewEntity] = []
    
    init() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: UIApplication.sharedApplication(), queue: NSOperationQueue.mainQueue()) { (_) in
            //TODO: clean
        }
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //Helpers
    
    var showAvatars: Bool {
        return SettingsManager.sharedInstance.showAvatar
    }
    
    func tweetsArrayToListEntitiesArray(tweetsArray:[Tweet]) -> [ListViewEntity] {
        var resultArray:[ListViewEntity] = []
        
        for tweet in tweetsArray {
            let entity = ListViewEntity(avatarImage: nil, tweet: tweet)
            resultArray.append(entity)
        }
        
        return resultArray
    }
    
    private func addTweets(tweetsToAdd:[Tweet]) {
        
        if tweetsToAdd.count == 0 {
            return
        }
        
        
        if tweetsEntities.last == nil || tweetsEntities.last!.tweetId > tweetsToAdd.first!.tweetId {
            
            //Case when either tweets array is empty or tweetsToAdd array should be appended to the end of tweets array
            
            tweetsEntities.appendContentsOf(tweetsArrayToListEntitiesArray(tweetsToAdd))
            userInterface?.addItemsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(tweetsEntities.count - tweetsToAdd.count, tweetsToAdd.count)))
        }else{
            
            //Tweets array is not empty
            
            //TODO: Need to be more safe with index to insert. Default value 0 is not really good idea
            var indexToInsert:Int = 0
            
            for (ind,tweetEntity) in tweetsEntities.enumerate() {
                if tweetEntity.tweetId < tweetsToAdd.last!.tweetId {
                    indexToInsert = ind
                    break
                }
            }
            
            tweetsEntities.insertContentsOf(tweetsArrayToListEntitiesArray(tweetsToAdd), at: indexToInsert)
            userInterface?.addItemsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(indexToInsert, tweetsToAdd.count)))
        }
    }
    
    private func setAvatarImage(image: UIImage, forTweetWithId tweetId:UInt64, oldPositionInEntitiesArray: Int) {
        
        if tweetsEntities.count > oldPositionInEntitiesArray && tweetsEntities[oldPositionInEntitiesArray].tweetId == tweetId {
            var entity = tweetsEntities[oldPositionInEntitiesArray]
            entity.avatarImage = image
            tweetsEntities[oldPositionInEntitiesArray] = entity
            userInterface?.updateItemImageAtIndexes(NSIndexSet(index: oldPositionInEntitiesArray))
        }else{
            for (ind, tweetEntity) in tweetsEntities.enumerate() {
                if tweetEntity.tweetId == tweetId {
                    setAvatarImage(image, forTweetWithId: tweetId, oldPositionInEntitiesArray: ind)
                    break
                }
            }
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
        
        if listInteractor?.isRequiresLogin() ?? false {
            listWireframe?.presentLoginInterface()
        }
        
        dispatch_async(dispatch_get_main_queue()){
            self.userInterface?.showAvatars(self.showAvatars)
        }
        
        self.listInteractor?.getHomeTweets(nil, sinceTweetId: self.tweetsEntities.first?.tweetId, completion: { (recievedTweets, noMore, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if (error == nil) {
                    if !noMore {
                        self.tweetsEntities = []
                        self.userInterface?.reloadItems()
                    }
                    self.addTweets(recievedTweets)
                }
            })
        })
        
    }
    
    func refreshOnTop() {
        self.listInteractor?.getHomeTweets(nil, sinceTweetId: self.tweetsEntities.first?.tweetId, completion: { (recievedTweets, noMore, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if (error == nil) {
                    if !noMore {
                        self.tweetsEntities = []
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
        return tweetsEntities.count
    }
    
    func itemAtIndex(ind:Int)->Any {
        
        let entity = tweetsEntities[ind]
        
        if (showAvatars && entity.avatarImage == nil) {
            if let imageUrl = entity.tweet.user.avatarLargeUrl {
                ImageSource.sharedInstance.getImageWithUrl(imageUrl, completion: { (image, error) in
                    if let actualImage = image {
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.setAvatarImage(actualImage, forTweetWithId: entity.tweetId, oldPositionInEntitiesArray: ind)
                        })
                    }
                    
                })
            }
        }
        
        if (ind == tweetsEntities.count - 1) {
            userInterface?.showDownloadAtBottom()
            listInteractor?.getHomeTweets(tweetsEntities.last!.tweetId, sinceTweetId: nil, completion: { (recievedTweets, noMore, error) in
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
        
        
        return tweetsEntities[ind]
    }
}