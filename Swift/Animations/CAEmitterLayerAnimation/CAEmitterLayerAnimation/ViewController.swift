//
//  ViewController.swift
//  CAEmitterLayerAnimation
//
//  Created by 郭伟林 on 2017/8/28.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EmitterLayerAnimationable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startEmittering(CGPoint(x: view.center.x, y: view.bounds.size.height - 20))
    }

}

