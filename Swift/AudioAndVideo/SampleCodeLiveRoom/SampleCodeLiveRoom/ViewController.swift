//
//  ViewController.swift
//  SampleCodeLiveRoom
//
//  Created by 郭伟林 on 2017/9/15.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit
import AVKit
import GPUImage

class ViewController: UIViewController {
    
    @IBOutlet weak var beautyViewBottomCons: NSLayoutConstraint!
    
    fileprivate lazy var gpuImageVideoCamera: GPUImageVideoCamera? = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .front)
    
    fileprivate lazy var gpuImageViewPreview : GPUImageView = GPUImageView(frame: self.view.bounds)
    
    let bilateralFilter = GPUImageBilateralFilter()    // 磨皮
    let exposureFilter = GPUImageExposureFilter()      // 曝光
    let brightnessFilter = GPUImageBrightnessFilter()  // 美白
    let satureationFilter = GPUImageSaturationFilter() // 饱和
    
    fileprivate lazy var gpuImageMovieWriter : GPUImageMovieWriter = { [unowned self] in
        // 创建写入对象
        let writer = GPUImageMovieWriter(movieURL: self.fileURL, size: self.view.bounds.size)
        // 设置写入对象的属性...
        return writer!
        }()
    
    var fileURL: URL {
        return URL(fileURLWithPath: "\(NSTemporaryDirectory())test.mp4")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(fileURL.absoluteString)
        print("\(NSTemporaryDirectory())test.mp4")
        if FileManager.default.fileExists(atPath: "\(NSTemporaryDirectory())test.mp4") {
            try! FileManager.default.removeItem(at: self.fileURL)
        }
        
        gpuImageVideoCamera?.delegate = self
        gpuImageVideoCamera?.outputImageOrientation = .portrait
        gpuImageVideoCamera?.horizontallyMirrorFrontFacingCamera = true
        
        view.insertSubview(gpuImageViewPreview, at: 0)
        
        let filterGroup = getImageFilterGroup()
        filterGroup.addTarget(gpuImageViewPreview)
        
        gpuImageVideoCamera?.addTarget(filterGroup)
        gpuImageVideoCamera?.startCapture()
        
        gpuImageMovieWriter.encodingLiveVideo = true
        filterGroup.addTarget(gpuImageMovieWriter)
        
        gpuImageVideoCamera?.audioEncodingTarget = gpuImageMovieWriter
        gpuImageMovieWriter.startRecording()
    }
    
    fileprivate func getImageFilterGroup() -> GPUImageFilterGroup {
        let filterGroup = GPUImageFilterGroup()
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(satureationFilter)
        
        filterGroup.initialFilters = [bilateralFilter]
        filterGroup.terminalFilter = satureationFilter
        
        return filterGroup
    }
    
}

extension ViewController {
    
    @IBAction func rotateCamera() {
        gpuImageVideoCamera?.rotateCamera()
    }
    
    @IBAction func adjustBeautyEffect() {
        adjustBeautyView(constant: 0)
    }
    
    @IBAction func finishedBeautyEffect() {
        adjustBeautyView(constant: -250)
    }
    
    @IBAction func switchBeautyEffect(switchBtn: UISwitch) {
        if switchBtn.isOn {
            gpuImageVideoCamera?.removeAllTargets()
            let filterGroup = getImageFilterGroup()
            filterGroup.addTarget(gpuImageViewPreview)
            gpuImageVideoCamera?.addTarget(filterGroup)
        } else {
            gpuImageVideoCamera?.removeAllTargets()
            gpuImageVideoCamera?.addTarget(gpuImageViewPreview)
        }
    }
    
    private func adjustBeautyView(constant : CGFloat) {
        beautyViewBottomCons.constant = constant
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func changeSatureation(_ sender: UISlider) {
        satureationFilter.saturation = CGFloat(sender.value * 2)
    }
    
    @IBAction func changeBrightness(_ sender: UISlider) {
        // - 1 ~ 1
        brightnessFilter.brightness = CGFloat(sender.value) * 2 - 1
    }
    
    @IBAction func changeExposure(_ sender: UISlider) {
        // - 10 ~ 10
        exposureFilter.exposure = CGFloat(sender.value) * 20 - 10
    }
    
    @IBAction func changeBilateral(_ sender: UISlider) {
        bilateralFilter.distanceNormalizationFactor = CGFloat(sender.value) * 8
    }
    
}

extension ViewController : GPUImageVideoCameraDelegate {
    
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        print("willOutputSampleBuffer")
    }
    
}

extension ViewController {
    
    @IBAction func stopRecording() {
        gpuImageVideoCamera?.stopCapture()
        gpuImageViewPreview.removeFromSuperview()
        gpuImageMovieWriter.finishRecording()
    }
    
    @IBAction func playVideo() {
        let avPlayerVC = AVPlayerViewController()
        avPlayerVC.player = AVPlayer(url: fileURL)
        present(avPlayerVC, animated: true, completion: nil)
    }
    
}

