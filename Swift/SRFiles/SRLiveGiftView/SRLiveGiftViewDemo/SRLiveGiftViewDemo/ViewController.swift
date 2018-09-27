//
//  ViewController.swift
//  SRLiveGiftViewDemo
//
//  Created by Willing Guo on 2017/9/11.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate lazy var liveGiftView: SRLiveGiftView = SRLiveGiftView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveGiftView.frame = CGRect(x: 0, y: 64, width: 300, height: 98)
        view.addSubview(liveGiftView)
    }

    @IBAction func showGift1(_ sender: Any) {
        let gift1 = SRLiveGiftModel(iconURLString: "icon1", senderName: "coder1", giftName: "gift1", giftURLString: "gift1")
        liveGiftView.showGift(gift1)
    }
    
    @IBAction func showGift2(_ sender: Any) {
        let gift2 = SRLiveGiftModel(iconURLString: "icon2", senderName: "coder2", giftName: "gift2", giftURLString: "gift2")
        liveGiftView.showGift(gift2)
    }
    
    @IBAction func showGift3(_ sender: Any) {
        let gift3 = SRLiveGiftModel(iconURLString: "icon3", senderName: "coder3", giftName: "gift3", giftURLString: "gift3")
        liveGiftView.showGift(gift3)
    }
}
