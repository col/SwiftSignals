//
//  SignalRTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 21/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public protocol SignalRTransport {
    
    init(connection: SignalRConnection, baseUrl: NSURL, networking: SignalRNetworking)
    
    func negotiate(completion: (response: AnyObject?) -> Void)
 
    func connect(completion: (response: AnyObject?) -> Void)
    
}