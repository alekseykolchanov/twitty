//
//  ListViewEntity.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 29/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit


struct ListViewEntity {
    
    var tweetId: UInt64 {
        return tweet.tweetId
    }
    
    var userName: String? {
        return tweet.user.userName
    }
    
    var userAtName: String? {
        return "@"+tweet.user.userAtName
    }
    
    var tweetText: String? {
        return tweet.text
    }
    
    var dateString: String? {
        return "\(tweet.tweetDate)"
    }
    
    var avatarImage:UIImage?
    
    let tweet: Tweet
    
}
