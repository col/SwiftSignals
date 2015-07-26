//
//  Networking.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public typealias SuccessHandler = (response: AnyObject?) -> Void
public typealias FailureHandler = (error: NSError?) -> Void

public protocol Networking {
    
    func get(url: NSURL, success: SuccessHandler, failure: FailureHandler)
    
    func get(url: NSURL, params: [String: AnyObject]?, success: SuccessHandler, failure: FailureHandler)

    func post(url: NSURL, body: [String: AnyObject]?, success: SuccessHandler, failure: FailureHandler)
    
}