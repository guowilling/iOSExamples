//
//  ViewController.swift
//  其他滤镜
//
//  Created by 郭伟林 on 2017/9/6.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var originalImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        originalImage = imageView.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func hese() {
        let heseFilter = GPUImageSepiaFilter()
        imageView.image = processImage(heseFilter)
    }
    
    @IBAction func katong() {
        let heseFilter = GPUImageToonFilter()
        imageView.image = processImage(heseFilter)
    }
    
    @IBAction func sumiao() {
        let heseFilter = GPUImageSketchFilter()
        imageView.image = processImage(heseFilter)
    }
    
    @IBAction func fudiao() {
        let heseFilter = GPUImageEmbossFilter()
        imageView.image = processImage(heseFilter)
    }
    
    private func processImage(_ filter : GPUImageFilter) -> UIImage? {
        let imagePicture = GPUImagePicture(image: originalImage)
        imagePicture?.addTarget(filter)
        filter.useNextFrameForImageCapture()
        imagePicture?.processImage()
        return filter.imageFromCurrentFramebuffer()
    }
    
}

