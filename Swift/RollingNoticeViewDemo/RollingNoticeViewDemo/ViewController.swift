//
//  ViewController.swift
//  RollingNoticeView
//
//  Created by 郭伟林 on 2018/10/31.
//  Copyright © 2018年 BITMAIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rollingNoticeView = RollingNoticeView(frame: CGRect(x: 50, y: 100, width: self.view.frame.width - 50 * 2, height: 44))
        rollingNoticeView.backgroundColor = UIColor.black
        let attrText = NSMutableAttributedString(string: "1234567890abc0987654321")
        attrText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),
                                NSAttributedStringKey.foregroundColor: UIColor.red], range: NSMakeRange(0, attrText.length))
        rollingNoticeView.attrText = attrText
        rollingNoticeView.setOnClickedNoticeClosure { (noticeView, notice) in
            noticeView.stopRolling()
            noticeView.removeFromSuperview()
            print(notice)
        }
        self.view.addSubview(rollingNoticeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

