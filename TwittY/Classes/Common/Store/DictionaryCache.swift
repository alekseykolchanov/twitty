//
//  ImageStore.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 29/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import Foundation

class DictionaryCache<T> {
    
    private let queue = dispatch_queue_create("DictionaryCacheQueue", DISPATCH_QUEUE_CONCURRENT)
    
    private var cacheDictionary:[String:T] = [ : ]
    
    func cleanCache() {
        dispatch_barrier_async(queue) { 
            self.cacheDictionary = [ : ]
        }
    }
    
    subscript(key:String)->T? {
        get {
            var result:T?
            dispatch_sync(queue) { 
                result = self.cacheDictionary[key]
            }
            
            return result
        }
        
        set {
            dispatch_barrier_async(queue) { 
                self.cacheDictionary[key] = newValue
            }
        }
    }
    
    
}