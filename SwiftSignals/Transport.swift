//
//  Transport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 21/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public protocol Transport {
    
    init(connection: Connection, delegate: TransportDelegate)
    
    var name: String { get }
    
    func negotiate(completion: (connectionOptions: ConnectionOptions) -> Void)
 
    func connect()
    
    func start()
    
    func invoke(method: String, args: [AnyObject]?)
    
}