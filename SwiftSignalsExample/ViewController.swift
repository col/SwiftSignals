//
//  ViewController.swift
//  SwiftSignalsExample
//
//  Created by Colin Harris on 30/7/15.
//  Copyright © 2015 Colin Harris. All rights reserved.
//

import UIKit
import SwiftSignals

class ViewController: UIViewController, ConnectionDelegate {

    @IBOutlet var connectionStateLabel: UILabel?
    @IBOutlet var console: UITextView?
    var connection: Connection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connection = Connection(baseUrlString: "http://ruw-net-01.cloudapp.net")
        connection?.delegate = self
    }

    @IBAction func connectClicked() {
        connection?.start()
    }

    @IBAction func disconnectClicked() {
        connection?.stop()
    }
    
    @IBAction func echoClicked() {
        self.appendToConsole("Sending echo")
        connection?.invoke("Echo", args: nil)
    }

    @IBAction func clearConsoleClicked() {
        console!.text = ""
    }
    
    func appendToConsole(string: String) {
        print(string)
        console!.text = console!.text + string + "\n"
    }
    
    func connectionDidOpen(connection: Connection) {
        self.appendToConsole("ConnectionDidOpen")
    }
    
    func connectionDidClose(connection: Connection) {
        self.appendToConsole("ConnectionDidClose")
    }
    
    func connectionError(connection: Connection, error: NSError?) {
        let error = error ?? NSError(domain: "", code: 0, userInfo: nil)
        self.appendToConsole("ConnectionError - \(error.localizedDescription)")
    }
    
    func connectionDidReceiveData(connection: Connection, data: AnyObject) {
        self.appendToConsole("ConnectionDidReceiveData")
    }
    
    func connectionDidReceiveEvent(connection: Connection, event: Event) {
        let args = event.arguments ?? [AnyObject]()
        self.appendToConsole("Event Received - Method: \(event.methodName) Args: \(args)")
    }
    
    func connectionStateDidChange(connection: Connection, fromState: ConnectionState, toState:ConnectionState) {
        self.appendToConsole("\(toState.rawValue)")
        connectionStateLabel?.text = toState.rawValue
    }

}

