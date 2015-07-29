//
//  SeverSentEventsTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 23/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation
import IKEventSource

public class ServerSentEventsTransport: BaseTransport {
    
    public var eventSource: EventSource?
    
    override public var name: String {
        get {
            return "serverSentEvents"
        }
    }
    
    override public func connect() {
        print("Connecting to: \(connectUrl())")
        eventSource = EventSource(url: connectUrl().absoluteString, headers: [String: String]())
        eventSource?.onOpen(self.onOpen)
        eventSource?.onError(self.onError)
        eventSource?.onMessage(self.onMessage)
    }
    
    func onOpen() {
        print("onOpen")
    }
    
    func onError(error: NSError?) {
        print("onError \(error)")
        if let error = error {
            self.delegate.transportError(error)
        }
    }
    
    func onMessage(id: String?, event: String?, data: String?) {
        print("onMessage id: \(id) event: \(event) data: \(data)")
        
        if data == "initialized" {
            self.start()
            return
        }
        
        do {
            let events = try self.parseResponse(data)
            events.map { (event) in
                delegate.transportDidReceiveEvent(event)
            }
        } catch {
            delegate.transportError(error as NSError)
        }
    }

    private func parseResponse(data: String?) throws -> [Event] {
        guard let data = data?.dataUsingEncoding(NSUTF8StringEncoding) else {
            return [Event]()
        }
        
        let response = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String : AnyObject]
        if let messages = response["M"] as? [[String: AnyObject]] {
            return messages.map { (message) in
                return Event.eventWithData(message)!
            }
        }
        
        return [Event]()
    }

}