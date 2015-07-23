//
//  NSURLComponentsTests.swift
//  SwiftSignals
//
//  Created by Colin Harris on 23/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import XCTest
@testable import SwiftSignals

class NSURLComponentsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // TODO: Need to figure out how to get NSURLComponents to encode the token correctly.
    // see: http://stackoverflow.com/questions/31577188/how-to-encode-into-2b-with-nsurlcomponents
    func xtestCreateAConnection() {
        let token = "abc+def"
        let baseUrl = NSURL(string: "http://www.example.com")
        let components = NSURLComponents(URL: baseUrl!, resolvingAgainstBaseURL: true)
        components?.queryItems = [ NSURLQueryItem(name: "connectionToken", value: token) ]
        
        XCTAssertEqual(components!.string!, "http://www.example.com/signalr/connect?connectionToken=abc%2Bdef")
    }
 
    func testEncodeToken() {
        let token = "abc+def"
        let customCharSet = NSMutableCharacterSet.alphanumericCharacterSet()
        let encodedToken = token.stringByAddingPercentEncodingWithAllowedCharacters(customCharSet)
        XCTAssertEqual(encodedToken!, "abc%2Bdef")
    }
}
