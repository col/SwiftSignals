//
//  MockConnectionDelegate.swift
//  SwiftSignals
//
//  Created by Colin Harris on 25/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import SwiftSignals

class MockConnectionDelegate: ConnectionDelegate {
    
    var connectionDidOpenWasCalled = false
    var connectionDidCloseWasCalled = false
    var connectionErrorWasCalled = false
    var connectionDidReceiveDataWasCalled = false
    var connectionDidReceiveEventWasCalled = false
    
    func connectionDidOpen(connection: Connection) {
        connectionDidOpenWasCalled = true
    }
    
    func connectionDidClose(connection: Connection) {
        connectionDidCloseWasCalled = true
    }
    
    func connectionError(connection: Connection, error: NSError?) {
        connectionErrorWasCalled = true
    }
    
    func connectionDidReceiveData(connection: Connection, data: AnyObject) {
        connectionDidReceiveDataWasCalled = true
    }
    
    func connectionDidReceiveEvent(connection: Connection, event: Event) {
        connectionDidReceiveEventWasCalled = true
    }
    
}