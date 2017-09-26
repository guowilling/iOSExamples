//
//  ServerManager.swift
//  SocketServer
//
//  Created by 郭伟林 on 2017/9/26.
//  Copyright © 2017年 SR. All rights reserved.
//

import Cocoa

class ServerManager: NSObject {

    fileprivate lazy var serverSocket: TCPServer = TCPServer(addr: "192.168.232.130", port: 7575)
    
    fileprivate var isRunning: Bool = false
    
    fileprivate lazy var clientManagers: [ClientManager] = [ClientManager]()
    
}

extension ServerManager {
    
    func startRunning() -> Void {
        serverSocket.listen()
        isRunning = true
        
        DispatchQueue.global().async {
            while self.isRunning {
                guard let client = self.serverSocket.accept() else {
                    return
                }
                DispatchQueue.global().async {
                    let clientManager = ClientManager(tcpClient: client)
                    clientManager.delegate = self
                    self.clientManagers.append(clientManager)
                    clientManager.startReadMsg()
                }
            }
        }
    }
 
    func stopRunning() -> Void {
        isRunning = false
    }
    
}

extension ServerManager: ClientManagerDelegate {
    
    func clientManagerSendMsgToClient(_ data: Data) {
        for clientManager in clientManagers {
            clientManager.tcpClient.send(data: data)
        }
    }
    
    func clientManagerRemoveClient(_ clientManager: ClientManager) {
        guard let index = clientManagers.index(of: clientManager) else {
            return
        }
        clientManagers.remove(at: index)
    }
    
}
