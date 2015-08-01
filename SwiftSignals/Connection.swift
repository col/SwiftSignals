//
//  Connection.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public enum ConnectionState: String {
    case Disconnected, Connecting, Connected, Reconnecting
}

public class Connection: NSObject, NSURLSessionDelegate, TransportDelegate {
    
    public let baseUrl: NSURL
    
    public var transport: Transport?
    public var delegate: ConnectionDelegate?
    public var options: ConnectionOptions?
    public var state: ConnectionState = ConnectionState.Disconnected
    
    public init(baseUrlString: String) {
        self.baseUrl = NSURL(string: baseUrlString)!
        super.init()
        self.transport = AutoTransport(connection: self, delegate: self)
    }
    
    public func start() {
        if changeState(from: .Disconnected, to: .Connecting) {
            transport?.negotiate() { (connectionOptions: ConnectionOptions) in
                self.options = connectionOptions
            
                self.transport?.connect()
            }
        }
    }
    
    public func stop() {
        transport?.disconnect()
    }
    
    public func invoke(method: String, args: [AnyObject]?) {
        transport?.invoke(method, args: args)
    }
    
    private func changeState(from from: ConnectionState, to: ConnectionState) -> Bool {
        if state == from {
            setState(to)
            return true
        }
        return false
    }
    
    private func setState(value: ConnectionState) {
        let from = state
        state = value
        dispatch_async(dispatch_get_main_queue()) {
            self.delegate?.connectionStateDidChange(self, fromState: from, toState: state)
        }
    }
    
    public func transportDidConnect() {
        dispatch_async(dispatch_get_main_queue()) {
            self.setState(.Connected)
            self.delegate?.connectionDidOpen(self)
        }
    }

    public func transportDidDisconnect() {
        dispatch_async(dispatch_get_main_queue()) {
            self.setState(.Disconnected)
            self.delegate?.connectionDidClose(self)
        }
    }
    
    public func transportError(error: NSError) {
        dispatch_async(dispatch_get_main_queue()) {
            self.delegate?.connectionError(self, error: error)
        }
    }
    
    public func transportDidReceiveEvent(event: Event) {
        dispatch_async(dispatch_get_main_queue()) {
            self.delegate?.connectionDidReceiveEvent(self, event: event)
        }
    }
    
}