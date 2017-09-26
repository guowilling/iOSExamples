//
//  SocketManager.swift
//  SocketClient
//
//  Created by 郭伟林 on 2017/9/26.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

protocol SocketManagerDeleagate: class {
    
    func socketManager(_ socketManager: SocketManager, userJoinRoom user: UserInfo)
    func socketManager(_ socketManager: SocketManager, userExitRoom user: UserInfo)
    func socketManager(_ socketManager: SocketManager, chatMsg: ChatMessage)
    func socketManager(_ socketManager: SocketManager, giftMsg: GiftMessage)
    
}

class SocketManager {

    weak var delegate: SocketManagerDeleagate?
    
    fileprivate var tcpClient: TCPClient
    
    fileprivate var userInfo: UserInfo.Builder = {
        let userInfo = UserInfo.Builder()
        userInfo.name = "name: \(arc4random_uniform(10))"
        userInfo.level = 20
        userInfo.iconUrl = "iconUrl: \(arc4random_uniform(5))"
        return userInfo
    }()
    
    init(addr: String, port: Int) {
        tcpClient = TCPClient(addr: addr, port: port)
    }
    
}

extension SocketManager {
    
    func connectServer() -> Bool {
        return tcpClient.connect(timeout: 5).0
    }
    
    func startReadMsg() {
        DispatchQueue.global().async {
            while true {
                // 读取消息的长度
                guard let lengthMsg = self.tcpClient.read(4) else {
                    continue
                }
                let headData = Data(bytes: lengthMsg, count: 4)
                var length: Int = 0
                (headData as NSData).getBytes(&length, length: 4)
                
                // 读取消息的类型
                guard let typeMsg = self.tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type : Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                
                // 读取消息的内容
                guard let msg = self.tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
                // 处理消息
                DispatchQueue.main.async {
                    self.handleMsg(type: type, data: data)
                }
            }
        }
    }
    
    fileprivate func handleMsg(type: Int, data: Data) {
        switch type {
        case 0, 1:
            let user = try! UserInfo.parseFrom(data: data)
            type == 0 ? delegate?.socketManager(self, userJoinRoom: user) : delegate?.socketManager(self, userExitRoom: user)
        case 2:
            let chatMsg = try! ChatMessage.parseFrom(data: data)
            delegate?.socketManager(self, chatMsg: chatMsg)
        case 3:
            let giftMsg = try! GiftMessage.parseFrom(data: data)
            delegate?.socketManager(self, giftMsg: giftMsg)
        default:
            print("未知类型")
        }
    }
    
}

extension SocketManager {
    
    func sendUserJoinRoomMsg() {
        let msgData = (try! userInfo.build()).data()
        sendMsg(data: msgData, type: 0)
    }
    
    func sendUserExitRoomMsg() {
        let msgData = (try! userInfo.build()).data()
        sendMsg(data: msgData, type: 1)
    }
    
    func sendTextMsg(message: String) {
        let chatMsg = ChatMessage.Builder()
        chatMsg.user = try! userInfo.build()
        chatMsg.text = message
        
        let chatData = (try! chatMsg.build()).data()
        
        sendMsg(data: chatData, type: 2)
    }
    
    func sendGiftMsg(giftName : String, giftURL : String, giftCount : Int) {
        let giftMsg = GiftMessage.Builder()
        giftMsg.user = try! userInfo.build()
        giftMsg.giftname = giftName
        giftMsg.giftUrl = giftURL
        giftMsg.giftcount = Int32(giftCount)
        
        let giftData = (try! giftMsg.build()).data()
        
        sendMsg(data: giftData, type: 3)
    }
    
    func sendHeartBeat() {
        let heartString = "Heart beat is comming!"
        let heartData = heartString.data(using: .utf8)!
        sendMsg(data: heartData, type: 100)
    }
    
    func sendMsg(data : Data, type : Int) {
        // 消息的长度
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 消息的类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 拼接数据
        let totalData = headerData + typeData + data
        
        // 发送数据
        tcpClient.send(data: totalData)
    }
    
}
