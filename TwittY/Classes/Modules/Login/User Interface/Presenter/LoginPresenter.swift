//
//  LoginPresenter.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class LoginPresenter: LoginModuleInterface {
    
    var loginInteractor : LoginInteractor?
    var loginWireframe : LoginWireframe?
    
    //LoginModuleInterface
    func loginAction() {
        loginInteractor?.login({ (success, error) in
            if (success) {
                self.loginWireframe?.dismissLoginInterface()
            }
        })
    }
}