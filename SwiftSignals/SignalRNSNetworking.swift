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
        get(url, params: nil, completion: completion)
    }
    
    func get(url: NSURL, params: [String: AnyObject]?, completion: (response: AnyObject?) -> Void) {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)!
//        components.queryItems = self.queryItemsForParams(params)
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
    
    func post(url: NSURL, body: [String: AnyObject]?, completion: (response: AnyObject?) -> Void) {
        print("Sending POST request to: \(url)")
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        if let body = body {
            request.HTTPBody = encodeBody(body)
        }
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
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
    
    func encodeQueryValue(value: String) -> String {
        let customCharSet = NSMutableCharacterSet.alphanumericCharacterSet()
        return value.stringByAddingPercentEncodingWithAllowedCharacters(customCharSet)!
    }
    
    private func encodeBody(body: [String: AnyObject]) -> NSData? {
        let data = jsonEncode(body)
        if let data = data {
            let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            let nsString = "data=\(encodeQueryValue(dataString as String))" as NSString
            return nsString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        return nil
    }
    
    private func jsonEncode(body: [String: AnyObject]) -> NSData? {
        do {
            return try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            return nil
        }
    }
    
    private func queryItemsForParams(params: [String : AnyObject]) -> [NSURLQueryItem] {
        return params.map { (key, value) -> NSURLQueryItem in
            return NSURLQueryItem(name: key, value: "\(value)")
        }
    }
    
}