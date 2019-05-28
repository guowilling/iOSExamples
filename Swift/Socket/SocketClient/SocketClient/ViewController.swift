//
//  ViewController.swift
//  SocketClient
//
//  Created by 郭伟林 on 2017/9/26.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate lazy var socketManager: SocketManager = SocketManager(addr: "192.168.232.130", port: 7575)
    
    fileprivate var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if socketManager.connectServer() {
            print("连接服务器成功!")
            
            socketManager.startReadMsg()
            socketManager.delegate = self
            
            timer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        } else {
            print("连接服务器失败!")
        }
    }
    
    deinit {
        timer.invalidate()
        timer = nil
    }
    
}

extension ViewController {

    // 消息类型:
    // 进入房间 = 0
    // 离开房间 = 1
    // 文本 = 2
    // 礼物 = 3
    
    @IBAction func joinRoom() {
        socketManager.sendUserJoinRoomMsg()
    }
    
    @IBAction func leaveRoom() {
        socketManager.sendUserExitRoomMsg()
    }
    
    @IBAction func sendText() {
        socketManager.sendTextMsg(message: "文本消息")
    }
    
    @IBAction func sendGift() {
        socketManager.sendGiftMsg(giftName: "礼物消息", giftURL: "http://www.baidu.com", giftCount: 1000)
    }
    
}

extension ViewController {
    
    @objc fileprivate func sendHeartBeat() {
        socketManager.sendHeartBeat()
    }
    
}

extension ViewController: SocketManagerDeleagate {
    
    func socketManager(_ socketManager: SocketManager, userJoinRoom user: UserInfo) {
        print("\(user.name)" + " join room")
    }
    
    func socketManager(_ socketManager: SocketManager, userExitRoom user: UserInfo) {
        print("\(user.name)" + " exit room")
    }
    
    func socketManager(_ socketManager: SocketManager, chatMsg: ChatMessage) {
        print("\(chatMsg.text)")
    }
    
    func socketManager(_ socketManager: SocketManager, giftMsg: GiftMessage) {
        print("\(giftMsg.giftUrl)")
    }

}
