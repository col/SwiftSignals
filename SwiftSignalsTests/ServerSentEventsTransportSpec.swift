//
//  ServerSideEventsTransportSpec.swift
//  SwiftSignals
//
//  Created by Colin Harris on 26/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Quick
import Nimble
@testable import IKEventSource
@testable import SwiftSignals

class ServerSentEventsTransportSpec: QuickSpec {
    override func spec() {
        
        describe("when initialized") {

            var transport: ServerSentEventsTransport?
            var mockConnection: MockConnection?
            var mockDelegate: MockTransportDelegate?
            var mockNetworking: MockNetworking?
            
            beforeEach() {
                mockConnection = MockConnection(baseUrlString: "http://www.example.com")
                mockDelegate = MockTransportDelegate()
                mockNetworking = MockNetworking()
                
                transport = ServerSentEventsTransport(connection: mockConnection!, delegate: mockDelegate!)
                transport?.networking = mockNetworking!
            }
            
            describe("#connect") {
                
                let options = ConnectionOptions()
                
                beforeEach() {
                    options.connectionToken = "negotiated token"
                    mockConnection?.options = options
                }
                
                it("should create an event source with path /signalr/connect") {
                    transport?.connect()
                    
                    expect(transport?.eventSource).toNot(beNil())
                    expect(transport?.eventSource?.url.path).to(equal("/signalr/connect"))
                    // Not sure how to test the callbacks are setup correctly...
                }
                
            }
            
            describe("#onError") {
                
                it("should call the transportError delegate method with the error") {
                    let error = NSError(domain: "", code: 123, userInfo: nil)
                    transport?.onError(error)
                    
                    expect(mockDelegate?.transportErrorWasCalled).to(beTruthy())
                    expect(mockDelegate?.transportErrorWasCalledWithError).to(beIdenticalTo(error))
                }
                
            }
            
            describe("#onMessage") {
                
                let options = ConnectionOptions()
                
                beforeEach() {
                    options.connectionToken = "negotiated token"
                    mockConnection?.options = options
                }
                
                describe("when the 'initialized' message is receiver") {
                    
                    it("should send a start request") {
                        transport?.onMessage(nil, event: nil, data: "initialized")
                        
                        expect(mockNetworking?.getWasCalled).to(beTruthy())
                        expect(mockNetworking?.getCalledWithURL?.path).to(equal("/signalr/start"))
                    }
                    
                }
                
                describe("when an event is received") {
                    
                    let messageDataObject = [
                        "M": [
                            [ "H" : "testhub", "M" : "tick", "A" : [] ]
                        ]
                    ]
                    
                    it("should call the transportShouldReceiveEvent with the correct event properties") {
                        let messageData = TestHelpers.jsonEncodeObject(messageDataObject)
                        transport?.onMessage(nil, event: "message", data: messageData)
                        
                        expect(mockDelegate?.transportDidReceiveEventWasCalled).to(beTruthy())

                        let receivedEvent = mockDelegate?.transportDidReceiveEventCalledWithEvent
                        expect(receivedEvent).toNot(beNil())
                        expect(receivedEvent?.hubName).to(equal("testhub"))
                        expect(receivedEvent?.methodName).to(equal("tick"))
                        expect(receivedEvent?.arguments).to(beEmpty())
                    }
                    
                }
                
            }        

        }
    
    }
}
