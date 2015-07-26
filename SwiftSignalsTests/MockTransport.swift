//
//  MockTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 25/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import SwiftSignals

class MockTransport: BaseTransport {
    
    var negotiateWasCalled = false
    var connectWasCalled = false
    var startWasCalled = false
    var invokeWasCalled = false
    
    var negotiateResponse: ConnectionOptions?
    var connectResponse: AnyObject?
    
    required init(connection: Connection, delegate: TransportDelegate) {
        super.init(connection: connection, delegate: delegate)
    }
    
    override var name: String {
        get {
            return "mockTransport"
        }
    }
    
    override func negotiate(completion: (connectionOptions: ConnectionOptions) -> Void) {
        negotiateWasCalled = true
        if let options = negotiateResponse {
            completion(connectionOptions: options)
        }
    }
    
    override func connect() {
        connectWasCalled = true
        start()
    }
    
    override func start() {
        startWasCalled = false
        delegate.transportDidConnect()
    }
    
    override func invoke(method: String, args: [AnyObject]) {
        invokeWasCalled = true
    }
    
}
