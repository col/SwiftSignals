//
//  SignalRNetworking.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

protocol SignalRNetworking {
    
    func get(url: NSURL, completion: (response: AnyObject?) -> Void)
    
}