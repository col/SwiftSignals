//
//  TestHelpers.swift
//  SwiftSignals
//
//  Created by Colin Harris on 28/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

class TestHelpers {
    
    class func jsonEncodeObject(object: AnyObject) -> String {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions.PrettyPrinted)
            return NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        } catch {
            return ""
        }
    }
    
}