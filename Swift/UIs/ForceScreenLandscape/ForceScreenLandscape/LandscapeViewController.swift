//
//  LandscapeViewController.swift
//  ForceScreenLandscape
//
//  Created by 郭伟林 on 2019/5/31.
//  Copyright © 2019 SR. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .landscapeRight
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeRight
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        // iPhone XR
        
        print(view.frame) // (0.0, 0.0, 414.0, 896.0)
        print(view.safeAreaInsets) // UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        print(view.safeAreaLayoutGuide)
        print("----------")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        (UIApplication.shared.delegate as! AppDelegate).supportedInterfaceOrientations = .landscapeRight
        
        print(view.frame) // (0.0, 0.0, 414.0, 896.0)
        print(view.safeAreaInsets) // UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        print(view.safeAreaLayoutGuide)
        print("----------")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(view.frame) // (0.0, 0.0, 896.0, 414.0)
        print(view.safeAreaInsets) // UIEdgeInsets(top: 0.0, left: 44.0, bottom: 21.0, right: 44.0)
        print(view.safeAreaLayoutGuide)
        
        let label = UILabel()
        label.text = "LandscapeLeft"
        label.sizeToFit()
        label.center = view.center
        view.addSubview(label)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        (UIApplication.shared.delegate as! AppDelegate).supportedInterfaceOrientations = .portrait
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.popViewController(animated: false)
//        dismiss(animated: false, completion: nil)
    }
    
}
