//
//  ViewController.swift
//  SwiftExtensions
//
//  Created by 郭伟林 on 2018/9/28.
//  Copyright © 2018年 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let testView = UIView()
        testView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        testView.center = view.center
        testView.backgroundColor = UIColor.red
        testView.round(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadi: 10.0)
        
        let borderLayer = CAShapeLayer()
        borderLayer.frame = testView.bounds
        borderLayer.path = (testView.layer.mask as! CAShapeLayer).path
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1.0
        testView.layer.addSublayer(borderLayer)
        
        view.addSubview(testView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

