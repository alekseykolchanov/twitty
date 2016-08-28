//
//  ListPresenter.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class ListPresenter: ListModuleInterface {
    
    var listWireframe: ListWireframe?
    var listInteractor: ListInteractor?
    
    
    var tweets:[Tweet] = []
    
    
    init() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: UIApplication.sharedApplication(), queue: NSOperationQueue.mainQueue()) { (_) in
            //TODO: clean
        }
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        listInteractor?.getTweetsAfter(tweets.first?.tweetId, completion: { (tweets, error) in
            
        })
    }
}