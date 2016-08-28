//
//  ListWireFrame.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class ListWireframe: BaseWireframe {
    var detailWireframe : DetailWireframe?
    var listPresenter : ListPresenter?
    var rootWireframe : RootWireframe?
    var listViewController : ListViewController?
    
    func presentListInterfaceFromWindow(window: UIWindow) {
        let viewController = listViewControllerFromStoryboard()
//        viewController.eventHandler = listPresenter
        listViewController = viewController
//        listPresenter!.userInterface = viewController
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func showDetailInterface() {
        detailWireframe?.showDetailInterfaceFromViewController(listViewController!, withTweet: Tweet(text: ""))
    }
    
    func listViewControllerFromStoryboard() -> ListViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateWithViewControllerIdentifier(ViewControllerIdentifier.List) as! ListViewController
        return viewController
    }
    
}