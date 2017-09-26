//
//  ViewController.swift
//  高斯模糊滤镜
//
//  Created by 郭伟林 on 2017/9/6.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sourceImage = imageView.image
        
        let imagePicture = GPUImagePicture(image: sourceImage)
        
        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.texelSpacingMultiplier = 2
        blurFilter.blurRadiusInPixels = 2
        
        imagePicture?.addTarget(blurFilter)
        
        blurFilter.useNextFrameForImageCapture()
        imagePicture?.processImage()
        
        let newImage = blurFilter.imageFromCurrentFramebuffer()
        
        imageView.image = newImage
    }
    
}

