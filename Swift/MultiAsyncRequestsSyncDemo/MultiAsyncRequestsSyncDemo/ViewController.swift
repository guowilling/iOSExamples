//
//  ViewController.swift
//  MultiAsyncRequestsSyncDemo
//
//  Created by 郭伟林 on 2018/12/4.
//  Copyright © 2018年 BITMAIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let hosts = ["https://www.baidu.com", "https://www.google.com", "https://cn.bing.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 需求: A B C 任务都执行完了, 再执行 D 任务
        
//        testGroupNotifyNormal() // not work
        
//        testGroupNotifyEnterLeave() // work
        
        testGroupNotifySemaphore() // work
    }

    private func testGroupNotifyNormal() {
        let group = DispatchGroup()
        for (i, host) in hosts.enumerated() {
            DispatchQueue.global().async(group: group, qos: .default, flags: []) {
                sleep(UInt32(i))
                print("\(Thread.current)" + " ***** " + "request: \(host)")
//                URLSession.shared.dataTask(with: URL(string: host)!, completionHandler: { (data, rsp, error) in
//                    print("\(Thread.current)" + " ***** " + "response: \(host)")
//                }).resume()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print("\(Thread.current)" + " ***** " + "notify called")
        }
        
        print("testGroupNotifyNormal go on")
    }
    
    private func testGroupNotifyEnterLeave() {
        let group = DispatchGroup()
        for (i, host) in hosts.enumerated() {
            DispatchQueue.global().async(group: group, qos: .default, flags: []) {
                group.enter()
                print("\(Thread.current)" + " ***** " + "request: \(host)")
                URLSession.shared.dataTask(with: URL(string: host)!, completionHandler: { (data, rsp, error) in
                    sleep(UInt32(i))
                    print("\(Thread.current)" + " ***** " + "response: \(host)")
                    group.leave()
                }).resume()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print("\(Thread.current)" + " ***** " + "notify called")
        }
        print("testGroupNotifyEnterLeave go on")
    }
    
    private func testGroupNotifySemaphore() {
        let group = DispatchGroup()
        for (i, host) in hosts.enumerated() {
            DispatchQueue.global().async(group: group, qos: .default, flags: []) {
                let semaphore = DispatchSemaphore(value: 0)
                print("\(Thread.current)" + " ***** " + "request: \(host)")
                URLSession.shared.dataTask(with: URL(string: host)!, completionHandler: { (data, response, error) in
                    sleep(UInt32(i))
                    print("\(Thread.current)" + " ***** " + "response: \(host)")
                    semaphore.signal()
                }).resume()
                semaphore.wait()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print("\(Thread.current)" + " ***** " + "notify called")
        }
        print("testGroupNotifySemaphore go on")
    }
}

