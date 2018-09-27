//
//  SRLiveGiftModel.swift
//  SRLiveGiftViewDemo
//
//  Created by Willing Guo on 2017/9/11.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class SRLiveGiftModel: NSObject {

    var iconURLString: String = ""
    var senderName: String = ""
    var giftName: String = ""
    var giftURLString: String = ""
    
    init(iconURLString: String, senderName: String, giftName: String, giftURLString: String) {
        self.iconURLString = iconURLString
        self.senderName = senderName
        self.giftName = giftName
        self.giftURLString = giftURLString
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? SRLiveGiftModel else {
            return false
        }
        guard object.senderName == senderName && object.giftName == giftName else {
            return false
        }
        return true
    }
}
