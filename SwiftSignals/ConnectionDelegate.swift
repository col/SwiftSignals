//
//  ConnectionDelegate.swift
//  SwiftSignals
//
//  Created by Colin Harris on 24/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public protocol ConnectionDelegate {
    
    func connectionDidOpen(connection: Connection)
    
    func connectionDidClose(connection: Connection)
    
    func connectionError(connection: Connection, error: NSError?)
    
    func connectionDidReceiveData(connection: Connection, data: AnyObject)
    
    func connectionDidReceiveEvent(connection: Connection, event: Event)
    
    func connectionStateDidChange(connection: Connection, fromState: ConnectionState, toState:ConnectionState)
    
}