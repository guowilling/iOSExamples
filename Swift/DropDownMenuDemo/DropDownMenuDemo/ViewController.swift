//
//  ViewController.swift
//  DropDownMenuDemo
//
//  Created by Willing Guo on 2018/10/19.
//  Copyright © 2018年 bitmain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tokenNames = ["BTC", "BCH", "ETH", "EOS", "HT", "USDT"]
    lazy var dropDownMenu: DropDownMenu = {
        let menu = DropDownMenu.init(frame: CGRect.init(x: 0, y: 64 + 20, width: self.view.frame.size.width, height: self.view.frame.size.height),
                                     dataSource: self.tokenNames,
                                     didSelectClosure: { (index) in
            print(index)
        })
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dropDownMenu)
    }


}

