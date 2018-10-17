//
//  ViewController.swift
//  FitScreenDemo
//
//  Created by Willing Guo on 2018/10/18.
//  Copyright © 2018年 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let fitLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 25)~
        lb.text = "https://github.com/guowilling"
        return lb
    }()
    
    fileprivate let fitView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(fitLabel)
        self.view.addSubview(fitView)
        
        fitLabel.sizeToFit()
        let fitX: CGFloat = 20
        let fitY: CGFloat = 100
        var fitLabelframe = fitLabel.frame
        fitLabelframe.origin.x = fitX~
        fitLabelframe.origin.y = fitY~
        fitLabel.frame = fitLabelframe
        
        let fitViewFrame = CGRect(x: 20, y: fitY, width: 100, height: 100)
        fitView.frame = fitViewFrame~
        fitView.frame.origin.y += fitLabel.frame.size.height
        fitView.frame.origin.y += 10~
    }
}

