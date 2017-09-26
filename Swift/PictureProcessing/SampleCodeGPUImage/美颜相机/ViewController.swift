//
//  ViewController.swift
//  美颜相机
//
//  Created by 郭伟林 on 2017/9/6.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {

    @IBOutlet var imageView : UIImageView!
    
    fileprivate lazy var camera : GPUImageStillCamera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .front)
    
    fileprivate lazy var filter = GPUImageBrightnessFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera.outputImageOrientation = .portrait
        
        filter.brightness = 0.1
        
        camera.addTarget(filter)
        
        let preImageView = GPUImageView(frame: view.bounds)
        view.insertSubview(preImageView, at: 0)
        filter.addTarget(preImageView)
        
        camera.startCapture()
    }
    
    @IBAction func takePhoto() {
        camera.capturePhotoAsImageProcessedUp(toFilter: filter, withCompletionHandler: { (image, error) in
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            
            self.imageView.image = image
            
            self.camera.stopCapture()
        })
    }

}

