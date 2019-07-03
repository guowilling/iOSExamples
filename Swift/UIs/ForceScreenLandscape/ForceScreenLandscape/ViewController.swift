//
//  ViewController.swift
//  ForceScreenLandscape
//
//  Created by 郭伟林 on 2019/5/31.
//  Copyright © 2019 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // iPhone XR
        
        print(view.frame) // (0.0, 0.0, 414.0, 896.0)
        print(view.safeAreaInsets) // UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        print(view.safeAreaLayoutGuide)
        print("----------")
    }

    // 1
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(view.frame) // (0.0, 0.0, 414.0, 896.0)
        print(view.safeAreaInsets) // UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        print(view.safeAreaLayoutGuide)
        print("----------")
    }
    
    // 3
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(view.frame) // (0.0, 0.0, 414.0, 896.0)
        print(view.safeAreaInsets) // UIEdgeInsets(top: 88.0, left: 0.0, bottom: 34.0, right: 0.0)
        print(view.safeAreaLayoutGuide)
        print("----------")
    }
    
    // 2
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(view.frame) // (0.0, 0.0, 414.0, 896.0)
        print(view.safeAreaInsets) // UIEdgeInsets(top: 88.0, left: 0.0, bottom: 34.0, right: 0.0)
        print(view.safeAreaLayoutGuide)
        print("----------")
    }
    
    @IBAction func nextPageAction(_ sender: UIBarButtonItem) {
//        (UIApplication.shared.delegate as! AppDelegate).supportedInterfaceOrientations = .landscapeRight
        
        //
//        (UIApplication.shared.delegate as! AppDelegate).isLandscapeLeft = true
//        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        
        //
        let landscapeVC = LandscapeViewController()
//        landscapeVC.view.backgroundColor = .white
        
        //
        navigationController?.pushViewController(landscapeVC, animated: false)
//        present(landscapeVC, animated: false, completion: nil)
    }
    
}

