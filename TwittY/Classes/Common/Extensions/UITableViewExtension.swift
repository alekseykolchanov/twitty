//
//  UITableViewExtension.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 28/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

enum TableViewCellIdentifier: String {
    case Tweet = "TweetTableViewCell"
}

extension UITableView {
    
    func dequeueReusableCellIdentifier(identifier: TableViewCellIdentifier)->UITableViewCell {
        return dequeueReusableCellWithIdentifier(identifier.rawValue)!
    }
}
