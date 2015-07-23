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
        get(url, params: [String: AnyObject](), completion: completion)
    }
    
    func get(url: NSURL, params: [String: AnyObject], completion: (response: AnyObject?) -> Void) {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)!
        components.queryItems = self.queryItemsForParams(params)
        print("Sending GET request to: \(components.URL!)")
        let task = session.dataTaskWithURL(
            components.URL!,
            completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    completion(response: jsonObject)
                } catch {
                    completion(response: nil)
                }
            }
        )
        task.resume()
    }
    
    private func queryItemsForParams(params: [String : AnyObject]) -> [NSURLQueryItem] {
        return params.map { (key, value) -> NSURLQueryItem in
            return NSURLQueryItem(name: key, value: "\(value)")
        }
    }
    
}