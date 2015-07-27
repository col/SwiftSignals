//
//  AutoTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 25/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

class AutoTransport: BaseTransport, TransportDelegate {
    
    var transport: Transport?
    
    override var name: String {
        get {
            return "autoTransport"
        }
    }
    
    override func negotiate(completion: (connectionOptions: ConnectionOptions) -> Void) {
        super.negotiate { (connectionOptions: ConnectionOptions) -> Void in
            if connectionOptions.tryWebSockets! {
                self.transport = WebSocketTransport(connection: self.connection, delegate: self)
            } else {
                self.transport = ServerSentEventsTransport(connection: self.connection, delegate: self)
            }
            completion(connectionOptions: connectionOptions)
        }
    }
    
    override func connect() {
        self.transport?.connect()
    }
    
    override func invoke(method: String, args: [AnyObject]) {
        self.transport?.invoke(method, args: args)
    }
    
    func transportDidConnect() {
        delegate.transportDidConnect()
    }

    func transportError(error: NSError) {
        print("transport error: \(error)")
        if transport?.name == "webSockets" {
            print("degrading from webSockets to serverSentEvents")
            transport = ServerSentEventsTransport(connection: connection, delegate: self)
            transport?.connect()
        } else {
            connection.delegate?.connectionError(connection, error: error)
        }
    }
    
    func transportDidReceiveEvent(event: Event) {
        delegate.transportDidReceiveEvent(event)
    }
    
}