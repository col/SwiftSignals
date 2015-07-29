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

    @IBOutlet var console: UITextView?
    var connection: Connection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connection = Connection(baseUrlString: "http://ruw-net-01.cloudapp.net")
        connection?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectClicked() {
        self.appendToConsole("Connecting...")
        connection?.start()
    }
    
    @IBAction func echoClicked() {
        self.appendToConsole("Sending echo")
        connection?.invoke("Echo", args: nil)
    }
    
    func appendToConsole(string: String) {
        print(string)
        console!.text = console!.text + string + "\n"
    }
    
    func connectionDidOpen(connection: Connection) {
        self.appendToConsole("connectionDidOpen")
    }
    
    func connectionDidClose(connection: Connection) {
        self.appendToConsole("connectionDidClose")
    }
    
    func connectionError(connection: Connection, error: NSError?) {
        self.appendToConsole("connectionError")
    }
    
    func connectionDidReceiveData(connection: Connection, data: AnyObject) {
        self.appendToConsole("connectionDidReceiveData")
    }
    
    func connectionDidReceiveEvent(connection: Connection, event: Event) {
        self.appendToConsole("connectionDidReceiveEvent")
        self.appendToConsole("Method: \(event.methodName)")
        self.appendToConsole("Args: \(event.arguments)")
    }

}

