//
//  ViewController.swift
//  SRChannelsControlDemo
//
//  Created by 郭伟林 on 2017/8/8.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        automaticallyAdjustsScrollViewInsets = false
        
        let pageViewFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        //let titles = ["标题1", "标题2", "标题3", "标题4", "标题5"]
        let titles = ["标题1", "标题2", "标题3", "标题4", "标题5", "标题666", "标题777", "标题888", "标题999"]
        
        let titleStyle = SRChannelsTitleStyle()
        titleStyle.isScrollEnabled = true
        titleStyle.isTitleScaling = true
        titleStyle.isBottomLineDisplayed = true;
        //titleStyle.isSliderDisplayed = true
        
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
        }
        
        let pageView = SRChannelsControl(frame: pageViewFrame, titles: titles, titleStyle: titleStyle, childVCs: childVCs, parentVC: self)
        
        view.addSubview(pageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

