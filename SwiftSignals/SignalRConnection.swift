//
//  SignalRConnection.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public class SignalRConnection : NSObject, NSURLSessionDelegate {
    
    let url: NSURL
    var transport: SignalRTransport?
    
    var connectionToken: String?
    var connectionId: String?
    var keepAliveTimeout: Float?
    var disconnectTimeout: Float?
    var connectionTimeout: Float?
    var transportConnectTimeout: Float?
    var longPollDelay: Float?
    var tryWebSockets: Bool?
    var protocolVersion: String?    
    
    public init(baseUrlString: String) {
        self.url = NSURL(string: baseUrlString)!
        super.init()
        self.transport = SignalRLongPollingTransport(connection: self, baseUrl: url, networking: SignalRNSNetworking())
    }
    
    public func start(block: () -> Void) {
        transport?.negotiate() { (response: AnyObject?) in
            guard let response = response else {
                print("#### handle the negotiation error ####")
                return
            }
            
            self.connectionId = response["ConnectionId"] as? String
            self.connectionToken = response["ConnectionToken"] as? String
            self.protocolVersion = response["ProtocolVersion"] as? String
            
            self.connectionTimeout = response["ConnectionTimeout"] as? Float
            self.disconnectTimeout = response["DisconnectTimeout"] as? Float
            self.keepAliveTimeout = response["KeepAliveTimeout"] as? Float
            self.longPollDelay = response["LongPollDelay"] as? Float
            self.transportConnectTimeout = response["TransportConnectTimeout"] as? Float
            
            self.tryWebSockets = response["TryWebSockets"] as? Bool
            
            
            self.transport?.connect() { (response: AnyObject?) in
            
                print("connect response: \(response)")
                
                block()
                
            }
            
        }
    }
    
}