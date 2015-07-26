//
//  SignalRConnectionSpec.swift
//  SwiftSignals
//
//  Created by Colin Harris on 23/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Quick
import Nimble
import SwiftSignals

class SignalRConnectionSpec: QuickSpec {
    override func spec() {
    
        describe("#init(baseUrlString:)") {
            
            it("should persist the baseUrl") {
                let connection = Connection(baseUrlString: "http://www.example.com")
                expect(connection.baseUrl.absoluteString).to(equal("http://www.example.com"))
            }
            
            it("should create a transport") {
                let connection = Connection(baseUrlString: "http://www.example.com")
                expect(connection.transport).toNot(beNil())
            }
            
        }
        
        describe("when the connection is initialized") {
            
            var connection: Connection?
            var mockDelegate: MockConnectionDelegate?
            var mockTransport: MockTransport?
            
            beforeEach() {
                connection = Connection(baseUrlString: "http://www.example.com")
                
                mockDelegate = MockConnectionDelegate()
                connection?.delegate = mockDelegate
                
                mockTransport = MockTransport(connection: connection!, delegate: connection!)
                connection?.transport = mockTransport
            }
            
            describe("#start") {
                
                it("should all negotiate") {
                    connection?.start()
                    
                    expect(mockTransport?.negotiateWasCalled).to(beTrue())
                }
                
                describe("when the negotiate call is successful") {

                    var mockOptions: ConnectionOptions?
                    
                    beforeEach() {
                        mockOptions = ConnectionOptions(data: [String: AnyObject]())
                        mockTransport?.negotiateResponse = mockOptions
                    }
                    
                    it("should set the connection options") {
                        connection?.start()
                        
                        expect(connection!.options!).to(beIdenticalTo(mockOptions))
                    }
                    
                    it("should call connect") {
                        connection?.start()
                        
                        expect(mockTransport?.connectWasCalled).to(beTrue())
                    }
                    
                    describe("when the connection is successful") {
                        
                        it("should call the connectionDidOpen delegate method") {
                            connection?.start()
                        
                            expect(mockDelegate?.connectionDidOpenWasCalled).to(beTrue())
                        }
                        
                    }
                    
                    xdescribe("when the connection fails") {
                        
                        beforeEach() {
                            
                        }
                        
                        it("should call the connectionError delegate method") {
                            connection?.start()
                            
                            expect(mockDelegate?.connectionErrorWasCalled).to(beTrue())
                        }
                    }
                    
                }
                
                describe("when the negotiate call is unsuccessful") {
                    
                    it("should...") {
                        
                    }
                    
                }
                
            }
            
//            describe("#invoke") {
//                
//                it("should send a request") {
//                    waitUntil(timeout: 10) { done in
//                        let connection = Connection(baseUrlString: "http://ruw-net-01.cloudapp.net")
//                        connection.start()
//                    }
//                }
//                
//            }
            
        }
        
        
        
        
        
    }
}

