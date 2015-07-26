//
//  Networking.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public protocol Networking {
    
    func get(url: NSURL, completion: (response: AnyObject?) -> Void)
    
    func get(url: NSURL, params: [String: AnyObject]?, completion: (response: AnyObject?) -> Void)

    func post(url: NSURL, body: [String: AnyObject]?, completion: (response: AnyObject?) -> Void)
    
}