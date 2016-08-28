//
//  RootWireframe.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

class RootWireframe : BaseWireframe {
    
    var loginWireframe: LoginWireframe?
    
    func presentLoginViewControllerFromViewController(viewController: UIViewController) {
        loginWireframe?.presentLoginInterfaceFromViewController(viewController)
    }
    
    func showRootViewController(viewController: UIViewController, inWindow: UIWindow) {
        let navigationController = navigationControllerFromWindow(inWindow)
        navigationController.viewControllers = [viewController]
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.presentLoginViewControllerFromViewController(viewController)
        }
    }
    
    func navigationControllerFromWindow(window: UIWindow) -> UINavigationController {
        let navigationController = window.rootViewController as! UINavigationController
        return navigationController
    }
}