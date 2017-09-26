//
//  ViewController.swift
//  SocketServer
//
//  Created by 郭伟林 on 2017/9/25.
//  Copyright © 2017年 SR. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var hintLabel: NSTextField!
    fileprivate lazy var serverManager: ServerManager = ServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startServer(_ sender: NSButton) {
        serverManager.startRunning()
        hintLabel.stringValue = "Server Is Running!"
    }
    
    @IBAction func stopServer(_ sender: NSButton) {
        serverManager.stopRunning()
        hintLabel.stringValue = "Server Is Resting..."
    }
    
}

