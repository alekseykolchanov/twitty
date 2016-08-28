//
//  BaseWireframe.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class BaseWireframe {
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func viewControllerFromStoryboard(viewControllerIdentifier: ViewControllerIdentifier) -> UIViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateWithViewControllerIdentifier(viewControllerIdentifier)
        return viewController
    }
    
}