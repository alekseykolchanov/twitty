//
//  ListModuleInterface.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation

protocol ListModuleInterface {
    
    func settingsAction()
    func searchAction()
    func selectTweetAction(tweet:Tweet)
    
    func updateViewOnAppear()
    func refreshOnTop()
}