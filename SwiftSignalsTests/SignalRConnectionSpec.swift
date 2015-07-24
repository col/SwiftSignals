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
    
        describe("#init(baseUrlString:webSocketsEnabled:)") {
            
            it("should create a transport") {
                let connection = SignalRConnection(baseUrlString: "http://www.example.com")
                expect(connection.transport).toNot(beNil())
            }
            
            it("should persist the baseUrl") {
                let connection = SignalRConnection(baseUrlString: "http://www.example.com")
                expect(connection.url.absoluteString).to(equal("http://www.example.com"))
            }
            
        }
        
        describe("#start") {
            
            it("should ...") {
                
            }
            
        }
        
        describe("#invoke") {
            
            it("should send a request") {
                waitUntil(timeout: 10) { done in
                    let connection = SignalRConnection(baseUrlString: "http://ruw-net-01.cloudapp.net")
                    connection.start() {
                        connection.invoke("SubscribeCustomer", args: [ "APAC-CUS-1-SG" ])
                    }
                }
            }
            
        }
        
        
        
    }
}

