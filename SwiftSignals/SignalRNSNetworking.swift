//
//  SignalRNSNetworking.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

class SignalRNSNetworking : SignalRNetworking {
    
    let session: NSURLSession
    
    init() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfig)
    }
    
    func get(url: NSURL, completion: (response: AnyObject?) -> Void) {
        let task = session.dataTaskWithURL(
            url,
            completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    completion(response: jsonObject)
                } catch {
                    completion(response: nil)
                }
            }
        )
        task?.resume()
    }
    
}