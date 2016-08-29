//
//  ImageSource.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 29/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class ImageSource{
    
    static let sharedInstance = ImageSource()
    
    let imageCache:DictionaryCache<UIImage> = DictionaryCache()
    
    
    let urlSession:NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        configuration.URLCache = NSURLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 25.0
        
        return NSURLSession(configuration: configuration)
    }()
    
    
    init() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: nil, queue: nil) { (_) in
            self.imageCache.cleanCache()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func getImageWithUrl(url:String, completion:(UIImage?, NSError?)->Void) {
        
        if let image = imageCache[url] {
            completion(image, nil)
        }
        
        if let request = requestForImageURL(url) {
            
            let dataTask = urlSession.dataTaskWithRequest(request, completionHandler: { (data, _, error) in
                
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                
                guard let actualData = data,
                    let receivedImage = UIImage(data: actualData) else {
                        completion(nil, ImageSourceError.ReceivedDataIsBad.error())
                        return
                }
                    
                self.imageCache[url] = receivedImage
                completion(receivedImage, nil)
                
            })
            
            dataTask.resume()
            
        }else{
            completion(nil, ImageSourceError.UrlIsWrong.error())
        }
        
    }
    
    private func requestForImageURL(urlString:String)->NSURLRequest? {
        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 25.0)
            request.HTTPMethod = "GET"
            return request
        }
        return nil
    }
    
}