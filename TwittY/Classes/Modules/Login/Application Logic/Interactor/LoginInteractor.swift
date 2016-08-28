//
//  LoginInteractor.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 28/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation

class LoginInteractor {
    
    var loginManager: TwitterAPIManager?
    
    func login(completion:(Bool, NSError?)->Void) {
        loginManager?.login({ (success, error) in
            completion(success, error)
        })
    }
}
