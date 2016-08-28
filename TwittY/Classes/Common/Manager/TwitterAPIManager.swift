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
}