//
//  UIStoryboardExtension.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation
import UIKit

enum ViewControllerIdentifier: String {
    case List = "ListViewController"
    case Login = "LoginViewController"
}

extension UIStoryboard {
    
    func instantiateWithViewControllerIdentifier(identifier:ViewControllerIdentifier)->UIViewController {
        return instantiateViewControllerWithIdentifier(identifier.rawValue)
    }

}
