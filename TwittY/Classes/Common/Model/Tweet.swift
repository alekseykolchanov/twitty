//
//  Tweet.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation

struct Tweet {
    
    let tweetId: UInt64
    let text:String?
    let tweetDate: NSDate
    
    let user: User
}

