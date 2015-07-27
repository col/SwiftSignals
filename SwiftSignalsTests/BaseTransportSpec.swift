//
//  BaseTransportSpec.swift
//  SwiftSignals
//
//  Created by Colin Harris on 27/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Quick
import Nimble
import SwiftSignals

class BaseTransportSpec: QuickSpec {
    override func spec() {
        
        describe("when initialized") {
            
            var transport: BaseTransport?
            var mockConnection: MockConnection?
            var mockDelegate: MockTransportDelegate?
            var mockNetworking: MockNetworking?
            
            beforeEach() {
                mockConnection = MockConnection(baseUrlString: "http://www.example.com")
                mockDelegate = MockTransportDelegate()
                mockNetworking = MockNetworking()
                
                transport = BaseTransport(connection: mockConnection!, delegate: mockDelegate!)
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
            
            describe("#start") {
                
                let options = ConnectionOptions()
                
                beforeEach() {
                    options.connectionToken = "negotiated token"
                    mockConnection?.options = options                    
                }
                
                it("should send a request to /signalr/start") {
                    transport?.start()
                    
                    expect(mockNetworking?.getCalledWithURL?.path).to(equal("/signalr/start"))
                }
                
                it("should send the correct params") {
                    
                }
                
                describe("when the request is successful") {
                    
                    beforeEach() {
                        mockNetworking?.setSuccess(nil)
                    }
                    
                    it("should call the transportDidConnect deleate method") {
                        transport?.start()
                        
                        expect(mockDelegate?.transportDidConnect).to(beTruthy())
                    }
                    
                }
                
                describe("when the request fails") {
                    
                    beforeEach() {
                        let error = NSError(domain: "", code: 123, userInfo: nil)
                        mockNetworking?.setFailure(error)
                    }
                    
                    it("should call the transportError deleate method") {
                        transport?.start()
                        
                        expect(mockDelegate?.transportErrorWasCalled).to(beTruthy())
                    }
                    
                }
                
            }
            
            describe("#invoke") {
                
                it("should ...") {
                    // TODO: continue tests here...
                }
                
            }
            
        }
    }
}