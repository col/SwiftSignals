//
//  TransportDelegate.swift
//  SwiftSignals
//
//  Created by Colin Harris on 26/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

public protocol TransportDelegate {
    
    func transportDidConnect()
    
    func transportError(error: NSError)
    
}
