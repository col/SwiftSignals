//
//  MockTransportDelegate.swift
//  SwiftSignals
//
//  Created by Colin Harris on 26/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import SwiftSignals

class MockTransportDelegate: TransportDelegate {
    
    var transportDidConnectWasCalled = false
    var transportErrorWasCalled = false

    func transportDidConnect() {
        transportDidConnectWasCalled = true
    }
    
    func transportError(error: NSError) {
        transportErrorWasCalled = true
    }
    
}
