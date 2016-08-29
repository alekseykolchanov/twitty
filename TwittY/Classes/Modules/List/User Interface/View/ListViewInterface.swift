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
    func reloadItems ()
    
    func showDownloadAtBottom()
    func hideDownloadAtBottom()
}