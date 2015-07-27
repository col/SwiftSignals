//
//  Connection.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public class Connection: NSObject, NSURLSessionDelegate, TransportDelegate {
    
    public let baseUrl: NSURL
    
    public var transport: Transport?
    public var delegate: ConnectionDelegate?
    public var options: ConnectionOptions?
    
    public init(baseUrlString: String) {
        self.baseUrl = NSURL(string: baseUrlString)!
        super.init()
        self.transport = AutoTransport(connection: self, delegate: self)
    }
    
    public func start() {
        transport?.negotiate() { (connectionOptions: ConnectionOptions) in
            self.options = connectionOptions
            
            self.transport?.connect()
        }
    }
    
    public func invoke(method: String, args: [AnyObject]) {
        transport?.invoke(method, args: args)
    }
    
    public func transportDidConnect() {
        delegate?.connectionDidOpen(self)
    }
    
    public func transportError(error: NSError) {
        delegate?.connectionError(self, error: error)
    }
    
    public func transportDidReceiveEvent(event: Event) {
        delegate?.connectionDidReceiveEvent(self, event: event)
    }
    
}