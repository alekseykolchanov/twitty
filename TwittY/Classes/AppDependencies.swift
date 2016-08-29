//
//  AppDependencies.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class AppDependencies {
    
    var listWireframe = ListWireframe()
    
    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow) {
        listWireframe.presentListInterfaceFromWindow(window)
    }
    
    func configureDependencies() {
        
        let rootWireframe = RootWireframe()
        
        
        let listPresenter = ListPresenter()
        let listInteractor = ListInteractor()
        
        let loginWireframe = LoginWireframe()
        let loginPresenter = LoginPresenter()
        let loginInteractor = LoginInteractor()
        
        let detailWireframe = DetailWireframe()
        
        
        
        rootWireframe.loginWireframe = loginWireframe
        
        listWireframe.detailWireframe = detailWireframe
        listWireframe.rootWireframe = rootWireframe
        listWireframe.listPresenter = listPresenter
        listWireframe.loginWireframe = loginWireframe
        
        listInteractor.twitterApiManager = TwitterAPIManager.sharedInstance
        listPresenter.listWireframe = listWireframe
        listPresenter.listInteractor = listInteractor
        
        loginWireframe.loginPresenter = loginPresenter
        loginInteractor.loginManager = TwitterAPIManager.sharedInstance
        loginPresenter.loginWireframe = loginWireframe
        loginPresenter.loginInteractor = loginInteractor
        
    }
}