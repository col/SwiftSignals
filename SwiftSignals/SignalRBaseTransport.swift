//
//  SignalRBaseTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

class SignalRBaseTransport : SignalRTransport {
    
    let baseUrl: NSURL
    let networking: SignalRNetworking
    
    required init(baseUrl: NSURL, networking: SignalRNetworking) {
        self.baseUrl = baseUrl
        self.networking = networking
    }
    
    func negotiate(completion: (response: AnyObject?) -> Void ) {
        let url = baseUrl.URLByAppendingPathComponent("/signalr/negotiate")
        networking.get(url) { (response: AnyObject?) in
            completion(response: response)
        }
    }
    
}