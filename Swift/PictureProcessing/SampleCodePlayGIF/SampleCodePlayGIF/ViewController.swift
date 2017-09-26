//
//  ViewController.swift
//  SampleCodePlayGIF
//
//  Created by 郭伟林 on 2017/9/1.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let path = Bundle.main.path(forResource: "demo.gif", ofType: nil) else {
            return
        }
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        guard let cgImageSource = CGImageSourceCreateWithData(data, nil) else {
            return
        }
        let imageCount = CGImageSourceGetCount(cgImageSource)
        
        var images = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0..<imageCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, i, nil) else {
                continue
            }
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            if i == 0 {
                imageView.image = image
            }
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(cgImageSource, i, nil) as? NSDictionary else {
                continue
            }
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else {
                continue
            }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else {
                continue
            }
            totalDuration += frameDuration.doubleValue
        }
        
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageView.stopAnimating()
    }
    
}

