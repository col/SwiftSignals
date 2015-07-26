//
//  BaseTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

public class BaseTransport: Transport {

    public let connection: Connection
    public let delegate: TransportDelegate
    public let networking: Networking
    
    required public init(connection: Connection, delegate: TransportDelegate) {
        self.connection = connection
        self.delegate = delegate
        self.networking = NSNetworking()
    }
    
    public var name: String {
        get {
            return "baseTransport"
        }
    }
    
    public func negotiate(completion: (connectionOptions: ConnectionOptions) -> Void ) {
        networking.get(negotiateUrl()) { (response) in
            let options = ConnectionOptions(data: response as! [String: AnyObject])
            completion(connectionOptions: options)
        }
    }
    
    public func connect() {
        // Abstract method. Should be implemented by subclass.
    }
    
    public func start() {
        networking.get(startUrl()) { (response) in
            self.delegate.transportDidConnect()
        }
    }
    
    public func invoke(method: String, args: [AnyObject]) {
        let event = Event(hubName: "dpbhub", methodName: method, arguments: args, index: 0)
        networking.post(sendUrl(), body: event.toData()) { (response) -> Void in
            print("Invoke Method Response!!! \(response)")
        }
    }

    func negotiateUrl() -> NSURL {
        return NSURL(string: "\(connection.baseUrl.absoluteString)/signalr/negotiate?\(negotiateQueryString())")!
    }

    func connectUrl() -> NSURL {
        return NSURL(string: "\(connection.baseUrl.absoluteString)/signalr/connect?\(connectQueryString())")!
    }
    
    func startUrl() -> NSURL {
        return NSURL(string: "\(connection.baseUrl.absoluteString)/signalr/start?\(connectQueryString())")!
    }
    
    func sendUrl() -> NSURL {
        return NSURL(string: "\(connection.baseUrl.absoluteString)/signalr/send?\(sendQueryString())")!
    }
    
    func connectParams() -> [String : AnyObject] {
        return [
            "connectionToken" : connection.options!.connectionToken!,
            "transport" : name,
            "clientProtocol" : "1.5",
            "connectionData" : [ ["name" : "dpbhub"] ]
        ]
    }

    func negotiateQueryString() -> String {
        let connectionData = encodeQueryValue("[{\"name\":\"dpbhub\"}]")
        return "clientProtocol=1.5&connectionData=\(connectionData)"
    }
    
    func connectQueryString() -> String {
        let token = encodeQueryValue(connection.options!.connectionToken!)
        let connectionData = encodeQueryValue("[{\"name\":\"dpbhub\"}]")
        return "transport=\(name)&clientProtocol=1.5&connectionToken=\(token)&connectionData=\(connectionData)"
    }

    func sendQueryString() -> String {
        return connectQueryString()
    }
    
    func encodeQueryValue(value: String) -> String {
        let customCharSet = NSMutableCharacterSet.alphanumericCharacterSet()
        return value.stringByAddingPercentEncodingWithAllowedCharacters(customCharSet)!
    }
    
}