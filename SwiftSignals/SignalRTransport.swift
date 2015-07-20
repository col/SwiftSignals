//
//  SignalRTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 21/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

protocol SignalRTransport {
    
    init(baseUrl: NSURL, networking: SignalRNetworking)
    
    func negotiate(completion: (response: AnyObject?) -> Void)
    
}