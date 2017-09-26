//
//  ClientManager.swift
//  SocketServer
//
//  Created by 郭伟林 on 2017/9/26.
//  Copyright © 2017年 SR. All rights reserved.
//

import Cocoa

protocol ClientManagerDelegate: class {
    
    func clientManagerSendMsgToClient(_ data: Data)
    
    func clientManagerRemoveClient(_ clientManager: ClientManager)
    
}

class ClientManager: NSObject {

    var tcpClient: TCPClient
    
    weak var delegate: ClientManagerDelegate?
    
    fileprivate var isConnected: Bool = false
    
    fileprivate var heartBeatTimeout: Int = 0
    
    init(tcpClient: TCPClient) {
        self.tcpClient = tcpClient
    }
    
}

extension ClientManager {
    
    func startReadMsg() {
        isConnected = true
        
        let timer = Timer(fireAt: Date(), interval: 1, target: self, selector: #selector(checkHeartBeatTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        timer.fire()
        
        while isConnected {
            if let lengthMsg = tcpClient.read(4) {
                // 读取消息的长度
                let headData = Data(bytes: lengthMsg, count: 4)
                var length: Int = 0
                (headData as NSData).getBytes(&length, length: 4)
                
                // 读取消息的类型
                guard let typeMsg = tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type: Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                
                // 读取消息的内容
                guard let msg = tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
                if type == 1 {
                    tcpClient.close()
                    delegate?.clientManagerRemoveClient(self)
                } else if type == 100 {
                    heartBeatTimeout = 0
                    continue
                }
                
                let totalData = headData + typeData + data
                delegate?.clientManagerSendMsgToClient(totalData)
            } else {
                self.removeClient()
            }
        }
    }
    
    @objc fileprivate func checkHeartBeatTime() {
        heartBeatTimeout += 1
        if heartBeatTimeout >= 10 {
            self.removeClient()
        }
    }
    
    private func removeClient() {
        tcpClient.close()
        isConnected = false
        delegate?.clientManagerRemoveClient(self)
    }
    
}
