//
//  ListViewInterface.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 29/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

protocol ListViewInterface {
    
    func addItemsAtIndexes(indexSet:NSIndexSet)
    func updateItemImageAtIndexes(indexSet:NSIndexSet)
    
    func reloadItems ()
    
    func showAvatars(isShow:Bool)
    
    func showDownloadAtBottom()
    func hideDownloadAtBottom()
    
    func showDownloadAtTop()
    func hideDownloadAtTop()
    
}