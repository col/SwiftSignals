//
//  NSNetworking.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

class NSNetworking: Networking {
    
    let session: NSURLSession
    
    init() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfig)
    }
    
    func get(url: NSURL, success: SuccessHandler, failure: FailureHandler) {
        get(url, params: nil, success: success, failure: failure)
    }
    
    func get(url: NSURL, params: [String: AnyObject]?, success: SuccessHandler, failure: FailureHandler) {
        print("Sending GET request to: \(url)")
        let task = session.dataTaskWithURL(
            url,
            completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let error = error {
                    failure(error: error)
                    return
                }
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    success(response: jsonObject)
                } catch let parseError as NSError {
                    failure(error: parseError)
                } catch {
                    failure(error: nil)
                }
            }
        )
        task.resume()
    }
    
    func post(url: NSURL, body: [String: AnyObject]?, success: SuccessHandler, failure: FailureHandler) {
        print("Sending POST request to: \(url)")
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        if let body = body {
            request.HTTPBody = encodeBody(body)
        }
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let error = error {
                    failure(error: error)
                    return
                }
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    success(response: jsonObject)
                } catch let parseError as NSError {
                    failure(error: parseError)
                } catch {
                    failure(error: nil)
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