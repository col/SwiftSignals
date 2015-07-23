//
//  SignalRSeverSentEventsTransport.swift
//  SwiftSignals
//
//  Created by Colin Harris on 23/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Foundation
import IKEventSource

class SignalRServerSentEventsTransport : SignalRBaseTransport {
    
    var eventSource: EventSource?
    
    required init(connection: SignalRConnection, baseUrl: NSURL, networking: SignalRNetworking) {
        super.init(connection: connection, baseUrl: baseUrl, networking: networking)
        self.transport = "serverSentEvents"
    }

    func connectURL() -> String {
        let customCharSet = NSMutableCharacterSet.alphanumericCharacterSet()
        let encodedToken = connection.connectionToken!.stringByAddingPercentEncodingWithAllowedCharacters(customCharSet)
        return "\(baseUrl.absoluteString)/signalr/connect?connectionToken=\(encodedToken!)&transport=\(transport)&clientProtocol=1.5"
    }
    
    override func connect(completion: (response: AnyObject?) -> Void) {
        
        // Can't get NSURLComponents to encode the token correctly.
        // see: http://stackoverflow.com/questions/31577188/how-to-encode-into-2b-with-nsurlcomponents
//        let components = NSURLComponents(URL: baseUrl, resolvingAgainstBaseURL: false)!
//        components.path = "/signalr/connect"
//        components.setQueryParams(connectParams())
//        print("SSE URL: \(components.string!)")

        print("SSE URL: \(connectURL())")
        eventSource = EventSource(url: connectURL(), headers: [String: String]())
        
        eventSource?.onOpen {
            print("onOpen")
        }
        
        eventSource?.onError { (error) in
            print("onError \(error)")
        }
        
        eventSource?.onMessage { (id, event, data) in
            print("onMessage id: \(id) event: \(event) data: \(data)")
            
            if data == "initialized" {
                completion(response: nil)
                return
            }
            
            let events = self.parseResponse(data)
            print("Received Events = \(events)")
        }
        
        eventSource?.addEventListener("event-name") { (id, event, data) in
            print("onEvent")
        }
        
//        eventSource?.close()
        
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