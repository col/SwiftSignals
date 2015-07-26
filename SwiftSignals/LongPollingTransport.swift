//
//  LongPollingTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

class LongPollingTransport: BaseTransport {
    
    override var name: String {
        get {
            return "longPolling"
        }
    }
    
    override func connect() {
        networking.get(connectUrl()) { (response) in
            self.start()
        }
    }
    
}