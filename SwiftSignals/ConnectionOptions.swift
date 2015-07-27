//
//  ConnectionOptions.swift
//  SwiftSignals
//
//  Created by Colin Harris on 25/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public class ConnectionOptions: NSObject {
    
    public var connectionToken: String?
    public var connectionId: String?
    public var keepAliveTimeout: Float?
    public var disconnectTimeout: Float?
    public var connectionTimeout: Float?
    public var transportConnectTimeout: Float?
    public var longPollDelay: Float?
    public var tryWebSockets: Bool?
    public var protocolVersion: String?
    
    override public init() {
        super.init()
    }
    
    public init(data: [String: AnyObject?]) {
        super.init()
        self.connectionId = data["ConnectionId"] as? String
        self.connectionToken = data["ConnectionToken"] as? String
        self.protocolVersion = data["ProtocolVersion"] as? String
        self.connectionTimeout = data["ConnectionTimeout"] as? Float
        self.disconnectTimeout = data["DisconnectTimeout"] as? Float
        self.keepAliveTimeout = data["KeepAliveTimeout"] as? Float
        self.longPollDelay = data["LongPollDelay"] as? Float
        self.transportConnectTimeout = data["TransportConnectTimeout"] as? Float
        self.tryWebSockets = data["TryWebSockets"] as? Bool
    }
    
}