//
//  SwiftSignalsTests.swift
//  SwiftSignalsTests
//
//  Created by Colin Harris on 20/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import XCTest
@testable import SwiftSignals

class SwiftSignalsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func xtestCreateAConnection() {
        let expectation = self.expectationWithDescription("asynchronous request")
        
        let connection = SignalRConnection(baseUrlString: "http://ruw-net-01.cloudapp.net", webSocketsEnabled: true)
        connection.start() {
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(15.0, handler:nil)
        
        XCTAssert(connection.connectionToken != nil)
        XCTAssert(connection.connectionId != nil)
        
        XCTAssertEqual(connection.keepAliveTimeout!, 20.0)
        XCTAssertEqual(connection.disconnectTimeout!, 30.0)
        XCTAssertEqual(connection.transportConnectTimeout!, 5.0)
        XCTAssertEqual(connection.connectionTimeout!, 110.0)
        XCTAssertEqual(connection.longPollDelay!, 0.0)
        
        XCTAssertEqual(connection.tryWebSockets!, false)
        XCTAssertEqual(connection.protocolVersion!, "1.5")
    }
    
}
