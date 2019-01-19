//
//  WWWW.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/1/19.
//  Copyright © 2019年 SR. All rights reserved.
//

import Foundation

extension Date {
    
    static func timeString(ofTimestamp timestamp: Int, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return formatter.string(from: date)
    }
    
    static func timeDescribe(ofTimestamp timestamp: Int) -> String {
        let compareDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        var timeInterval: Double = compareDate.timeIntervalSinceNow
        timeInterval = -timeInterval
        var interval: Double = 0;
        var describe = ""
        if timeInterval < 60 {
            describe = "刚刚"
        } else if (timeInterval / 60) < 60 {
            interval = timeInterval / 60
            describe = "\(Int(interval))分钟前"
        } else if (timeInterval / 60 / 60) < 24 {
            interval = timeInterval / 60 / 60
            describe = "\(Int(interval))小时前"
        } else if (timeInterval / 60 / 60 / 24) < 30 {
            interval = timeInterval / 60 / 60 / 24
            describe = "\(Int(interval))天前"
        } else if (timeInterval / 60 / 60 / 24 / 30) < 12 {
            interval = timeInterval / 60 / 60 / 24 / 30
            describe = "\(Int(interval))个月前"
        } else {
            interval = timeInterval / 60 / 60 / 24 / 30 / 12
            describe = "\(Int(interval))年前"
        }
        return describe
    }
}
