//
//  NSURLComponents+SwiftSignals.swift
//  SwiftSignals
//
//  Created by Colin Harris on 22/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

extension NSURLComponents {
    
    func setQueryParams(params: [String: AnyObject]) {
        self.queryItems = queryItemsForParams(params)
    }
    
    private func queryItemsForParams(params: [String : AnyObject]) -> [NSURLQueryItem] {
        return params.map { (key, value) -> NSURLQueryItem in            
            let encodedValue = "\(value)".stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet())
            return NSURLQueryItem(name: key, value: encodedValue)
        }
    }
    
}