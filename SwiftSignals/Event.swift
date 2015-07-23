//
//  Event.swift
//  SwiftSignals
//
//  Created by Colin Harris on 24/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public class Event {
    
    public let hubName: String
    public let methodName: String
    public let arguments: [AnyObject]
    public let index: Int
    
    init(hubName: String, methodName: String, arguments: [AnyObject], index: Int) {
        self.hubName = hubName
        self.methodName = methodName
        self.arguments = arguments
        self.index = index
    }
    
    class func eventWithData(data: [String: AnyObject]) -> Event? {
        if let hubName = data["H"] as? String,
            methodName = data["M"] as? String,
            arguments = data["A"] as? [AnyObject],
            index = data["I"] as? Int
        {
            return Event(hubName: hubName, methodName: methodName, arguments: arguments, index: index)
        }
        return nil
    }
    
}
