//
//  LoginWireframe.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit


class LoginWireframe: BaseWireframe {
    
    //Dependencies
    var loginPresenter : LoginPresenter?
    
    
    weak var presentedViewController: UIViewController?
    
    func presentLoginInterfaceFromViewController(viewController:UIViewController) {
        let loginViewController = viewControllerFromStoryboard(.Login) as! LoginViewController
        loginViewController.eventHandler = loginPresenter
        presentedViewController = loginViewController
        viewController.presentViewController(loginViewController, animated: false, completion: nil)
    }
    
    func dismissLoginInterface() {
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}