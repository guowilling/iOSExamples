//
//  ViewController.swift
//  视频采集
//
//  Created by 郭伟林 on 2017/9/6.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {
    
    fileprivate lazy var camera : GPUImageVideoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .back)
    
    fileprivate lazy var filter = GPUImageBrightnessFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera.outputImageOrientation = .portrait
        
        camera.addTarget(filter)
        
        camera.delegate = self
        
        let preGPUImageView = GPUImageView(frame: view.bounds)
        view.addSubview(preGPUImageView)
        filter.addTarget(preGPUImageView)
        
        camera.startCapture()
    }
}

extension ViewController : GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        print("采集到画面")
    }
}

