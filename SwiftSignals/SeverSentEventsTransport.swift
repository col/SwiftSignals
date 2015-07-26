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
    
    var eventSource: EventSource?
    
    override public var name: String {
        get {
            return "serverSentEvents"
        }
    }
    
    override public func connect() {
        print("Connecting to: \(connectUrl())")
        eventSource = EventSource(url: connectUrl().absoluteString, headers: [String: String]())
        
        eventSource?.onOpen {
            print("onOpen")
        }
        
        eventSource?.onError { (error) in
            print("onError \(error)")
            self.connection.delegate?.connectionError(self.connection, error: error)
        }
        
        eventSource?.onMessage { (id, event, data) in
            print("onMessage id: \(id) event: \(event) data: \(data)")
            
            if data == "initialized" {
                self.start()
                return
            }
            
            let events = self.parseResponse(data)
            print("Received Events = \(events)")
        }
        
    }
    
    private func parseResponse(data: String?) -> [Event] {
        guard let data = data?.dataUsingEncoding(NSUTF8StringEncoding) else {
            return [Event]()
        }
        
        var response: [String: AnyObject]?
        do {
            response = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String : AnyObject]
        } catch {
            print("Error parsing response! \(error)")
        }
        
        if let response = response, messages = response["M"] as? [[String: AnyObject]] {
            return messages.map { (message) in
                return Event.eventWithData(message)!
            }
        }
        
        return [Event]()
    }

}