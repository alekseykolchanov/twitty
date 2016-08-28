//
//  NSErrorExtension.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 28/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation

protocol ErrorFactory {
    func error() -> NSError
}

enum TwitterAPIManagerError: Int, ErrorFactory {
    case Unknown = 0
    case UnableToParseResponse = 1
    func error() -> NSError {
        return NSError(domain: "TwitterAPIErrorDomain", code: self.rawValue, userInfo: nil)
    }
}

