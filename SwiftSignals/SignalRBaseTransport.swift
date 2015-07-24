//
//  SignalRBaseTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation

class SignalRBaseTransport : SignalRTransport {

    let connection: SignalRConnection
    let baseUrl: NSURL
    let networking: SignalRNetworking
    var transport: String
    
    required init(connection: SignalRConnection, baseUrl: NSURL, networking: SignalRNetworking) {
        self.connection = connection
        self.baseUrl = baseUrl
        self.networking = networking
        self.transport = "longPolling"
    }
    
    func negotiate(completion: (response: AnyObject?) -> Void ) {
        networking.get(negotiateUrl()) { (response) in
            completion(response: response)
        }
    }
    
    func connect(completion: (response: AnyObject?) -> Void) {
        networking.get(connectUrl()) { (response) -> Void in
            self.start() {
                completion(response: response)
            }
        }
    }
    
    func start(completion: () -> Void) {
        networking.get(startUrl()) { (response) -> Void in
            print("Start Response!!! \(response)")
            completion()
        }
    }
    
    func invoke(method: String, args: [AnyObject]) {
        let event = Event(hubName: "dpbhub", methodName: method, arguments: args, index: 0)
        networking.post(sendUrl(), body: event.toData()) { (response) -> Void in
            print("Invoke Method Response!!! \(response)")
        }
    }

    func negotiateUrl() -> NSURL {
        return NSURL(string: "\(baseUrl.absoluteString)/signalr/negotiate?\(negotiateQueryString())")!
    }

    func connectUrl() -> NSURL {
        return NSURL(string: "\(baseUrl.absoluteString)/signalr/connect?\(connectQueryString())")!
    }
    
    func startUrl() -> NSURL {
        return NSURL(string: "\(baseUrl.absoluteString)/signalr/start?\(connectQueryString())")!
    }
    
    func sendUrl() -> NSURL {
        return NSURL(string: "\(baseUrl.absoluteString)/signalr/send?\(sendQueryString())")!
    }
    
    func connectParams() -> [String : AnyObject] {
        return [
            "connectionToken" : connection.connectionToken!,
            "transport" : transport,
            "clientProtocol" : "1.5",
            "connectionData" : [ ["name" : "dpbhub"] ]
        ]
    }

    func negotiateQueryString() -> String {
        let connectionData = encodeQueryValue("[{\"name\":\"dpbhub\"}]")
        return "clientProtocol=1.5&connectionData=\(connectionData)"
    }
    
    func connectQueryString() -> String {
        let token = encodeQueryValue(connection.connectionToken!)
        let connectionData = encodeQueryValue("[{\"name\":\"dpbhub\"}]")
        return "transport=\(transport)&clientProtocol=1.5&connectionToken=\(token)&connectionData=\(connectionData)"
    }

    func sendQueryString() -> String {
        return connectQueryString()
    }
    
    func encodeQueryValue(value: String) -> String {
        let customCharSet = NSMutableCharacterSet.alphanumericCharacterSet()
        return value.stringByAddingPercentEncodingWithAllowedCharacters(customCharSet)!
    }
    
}