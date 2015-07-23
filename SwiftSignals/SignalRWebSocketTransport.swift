//
//  SignalRWebSocketTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 22/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation
import Starscream

class SignalRWebSocketTransport : SignalRBaseTransport, WebSocketDelegate {
    
    var socket: WebSocket?
    var connectCallback: ((response: AnyObject?) -> Void)?
    
    required init(connection: SignalRConnection, baseUrl: NSURL, networking: SignalRNetworking) {
        super.init(connection: connection, baseUrl: baseUrl, networking: networking)
        self.transport = "webSockets"
    }
    
    override func connect(completion: (response: AnyObject?) -> Void) {
//        completion(response: nil)
        self.connectCallback = completion
        let components = NSURLComponents(URL: baseUrl, resolvingAgainstBaseURL: false)!
        components.scheme = "ws"
        components.path = "/signalr/connect"
        components.setQueryParams(connectParams())
        
        print("Sending WS request to: \(components.URL!)")
        socket = WebSocket(url: components.URL!)
        socket?.delegate = self
        socket?.connect()
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocketDidConnect")
        connectCallback!(response: nil);
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocketDidDisconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("websocketDidReceiveMessage")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("websocketDidReceiveData")
    }
    
}
