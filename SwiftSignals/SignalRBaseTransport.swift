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
        let url = baseUrl.URLByAppendingPathComponent("/signalr/negotiate")
        let params = [ "clientProtocol" : "1.5" ]
        networking.get(url, params: params) { (response) in
            completion(response: response)
        }
    }
    
    func connect(completion: (response: AnyObject?) -> Void) {
        let url = baseUrl.URLByAppendingPathComponent("/signalr/connect")
        networking.get(url, params: connectParams()) { (response) -> Void in
            completion(response: response)
        }
    }
    
    func connectParams() -> [String : AnyObject] {
        return [
            "connectionToken" : connection.connectionToken!,
            "transport" : transport,
            "clientProtocol" : "1.5"
            //            , "connectionData" : [ ["name" : "dpbhub"]
        ]
    }
}