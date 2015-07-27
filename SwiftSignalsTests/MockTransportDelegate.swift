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
    var transportErrorWasCalledWithError: NSError?

    var transportDidReceiveEventWasCalled = false
    var transportDidReceiveEventCalledWithEvent: Event?
    
    func transportDidConnect() {
        transportDidConnectWasCalled = true
    }
    
    func transportError(error: NSError) {
        transportErrorWasCalled = true
        transportErrorWasCalledWithError = error
    }
    
    func transportDidReceiveEvent(event: Event) {
        transportDidReceiveEventWasCalled = true
        transportDidReceiveEventCalledWithEvent = event
    }
    
}
