//
//  NSURL+SwiftSignalsSpec.swift
//  SwiftSignals
//
//  Created by Colin Harris on 26/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import Quick
import Nimble
import SwiftSignals

class NSURLSwiftSignalsSpec: QuickSpec {
    override func spec() {
        
        describe("#getQueryParams") {

            var url: NSURL?
            
            beforeEach() {
                url = NSURL(string: "http://www.example.com/index.php?key1=value1&key2=value2")
            }
            
            it("should return the correct query params") {
                let queryParams = url!.getQueryParams()
                
                expect(queryParams.count).to(equal(2))
                expect(queryParams["key1"]).to(equal("value1"))
                expect(queryParams["key2"]).to(equal("value2"))
            }
            
        }
    }
}