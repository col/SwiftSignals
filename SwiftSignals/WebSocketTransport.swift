//
//  WebSocketTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 22/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation
import Starscream

class WebSocketTransport: BaseTransport, WebSocketDelegate {
    
    var socket: WebSocket?
    
    override var name: String {
        get {
            return "webSockets"
        }
    }
    
    override func connect() {
        // TODO: fix this to append the query params correctly.
        let components = NSURLComponents(URL: connection.baseUrl, resolvingAgainstBaseURL: false)!
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
        start()
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocketDidDisconnect")
        // TODO: initiate a reconnect here.
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("websocketDidReceiveMessage")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("websocketDidReceiveData")
    }
    
}
