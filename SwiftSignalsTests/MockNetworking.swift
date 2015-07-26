//
//  MockNetworking.swift
//  SwiftSignals
//
//  Created by Colin Harris on 26/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import SwiftSignals

class MockNetworking: Networking {
    
    var isSuccess = true
    
    var response: AnyObject?
    var error: NSError?
    
    var getWasCalled = false
    var getCalledWithURL: NSURL?
    
    var postWasCalled = false
    var postCalledWithURL: NSURL?
    var postCalledWithBody: [String: AnyObject]?
    
    func setSuccess(response: AnyObject?) {
        isSuccess = true
        self.response = response
    }

    func setFailure(error: NSError?) {
        isSuccess = false
        self.error = error
    }
    
    func respond(success: SuccessHandler, failure: FailureHandler) {
        if isSuccess {
            success(response: response)
        } else {
            failure(error: error)
        }
    }
    
    func get(url: NSURL, success: SuccessHandler, failure: FailureHandler) {
        getWasCalled = true
        getCalledWithURL = url
        respond(success, failure: failure)
    }
    
    func get(url: NSURL, params: [String: AnyObject]?, success: SuccessHandler, failure: FailureHandler) {
        getWasCalled = true
        getCalledWithURL = url
        respond(success, failure: failure)
    }
    
    func post(url: NSURL, body: [String: AnyObject]?, success: SuccessHandler, failure: FailureHandler) {
        postWasCalled = true
        postCalledWithURL = url
        postCalledWithBody = body
        respond(success, failure: failure)
    }    
    
}

