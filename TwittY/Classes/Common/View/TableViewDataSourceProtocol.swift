//
//  TableViewDataSourceProtocol.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 29/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation

protocol TableViewDataSourceProtocol {
    func numberOfItems() -> Int
    func itemAtIndex(ind:Int)->Any
}