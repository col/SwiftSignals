//
//  ServerSideEventsTransportSpec.swift
//  SwiftSignals
//
//  Created by Colin Harris on 26/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Quick
import Nimble
import SwiftSignals

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

            describe("#negotiate") {
                
                beforeEach() {
                    mockNetworking?.setSuccess([String: AnyObject]())
                }
                
                it("should send a GET request to /signalr/negotiate") {
                    transport?.negotiate() { (connectionOptions) in
                        print("negotiated")
                    }
                    expect(mockNetworking?.getWasCalled).to(beTruthy())
                    
                    let url = mockNetworking?.getCalledWithURL
                    expect(url!.path).to(equal("/signalr/negotiate"))
                }
                
                it("should include the correct query params") {
                    transport?.negotiate() { (connectionOptions) in }

                    let url = mockNetworking!.getCalledWithURL!
                    let queryParams = url.getQueryParams()
                    expect(queryParams.count).to(equal(2))
                    expect(queryParams["clientProtocol"]).to(equal("1.5"))
                    expect(queryParams["connectionData"]).to(equal("%5B%7B%22name%22%3A%22dpbhub%22%7D%5D"))
                }
                
                describe("when the request is successful") {
                    
                    let response = [
                        "ConnectionId": "mock connection id",
                        "ConnectionToken": "mock connection token",
                        "ProtocolVersion": "1.2.3",
                        "ConnectionTimeout": 5,
                        "DisconnectTimeout": 10,
                        "KeepAliveTimeout": 15,
                        "LongPollDelay": 20,
                        "TransportConnectTimeout": 25,
                        "TryWebSockets": false
                    ]
                    
                    beforeEach() {
                        mockNetworking?.setSuccess(response)
                    }
                    
                    it("should parse the response into ConnectionOptions") {
                        var result: ConnectionOptions?
                        transport?.negotiate() { (connectionOptions) in
                            result = connectionOptions
                        }
                        expect(result?.connectionId).to(equal(response["ConnectionId"]))
                        expect(result?.connectionToken).to(equal(response["ConnectionToken"]))
                        expect(result?.protocolVersion).to(equal(response["ProtocolVersion"]))
                        expect(result?.connectionTimeout).to(equal(response["ConnectionTimeout"]))
                        expect(result?.disconnectTimeout).to(equal(response["DisconnectTimeout"]))
                        expect(result?.keepAliveTimeout).to(equal(response["KeepAliveTimeout"]))
                        expect(result?.longPollDelay).to(equal(response["LongPollDelay"]))
                        expect(result?.transportConnectTimeout).to(equal(response["TransportConnectTimeout"]))
                        expect(result?.tryWebSockets).to(equal(response["TryWebSockets"]))
                    }
                    
                }
                
                describe("when the request fails") {
                    
                    let error = NSError(domain: "", code: 123, userInfo: nil)
                    
                    beforeEach() {
                        mockNetworking?.setFailure(error)
                    }
                    
                    it("should call the transportError delegate method") {
                        transport?.negotiate() { (connectionOptions) in }
                        expect(mockDelegate!.transportErrorWasCalled).to(beTruthy())
                    }
                    
                }
                
            }
            
            describe("#connect") {
                
                it("should ...") {
                    
                }
            }
            
            describe("#start") {
                
                it("should ...") {
                    
                }
                
            }
            
            describe("#invoke") {
                
                it("should ...") {
                    
                }
                
            }

        }
    
    }
}
