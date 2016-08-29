//
//  SettingsManager.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 29/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation


class SettingsManager {
    
    //TODO: do register defaults via registerDefaults(...)
    
    
    static let sharedInstance = SettingsManager()
    
    
    enum SettingsManagerKey: String {
        case ShowAvatar = "SettingsManagerShowAvatarKey"
    }
    
    private func getSettingsObjectWithKey(key: SettingsManagerKey)->AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key.rawValue)
    }
    
    private func setSettingsObject(value:AnyObject?, forKey key: SettingsManagerKey) {
        if let actualValue = value {
            NSUserDefaults.standardUserDefaults().setObject(actualValue, forKey: key.rawValue)
        }else{
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.rawValue)
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private var _showAvatar: Bool?
    var showAvatar: Bool {
        get{
            if (_showAvatar == nil) {
                _showAvatar = getSettingsObjectWithKey(.ShowAvatar) as? Bool
            }
            
            if (_showAvatar == nil) {
                self.showAvatar = true
            }
            
            return _showAvatar!
        }
        set{
            _showAvatar = newValue
            setSettingsObject(_showAvatar, forKey: .ShowAvatar)
        }
    }
}