//
//  ViewController.swift
//  SampleCodeCaptureAudioAndVideo
//
//  Created by 郭伟林 on 2017/9/12.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    fileprivate var videoInput: AVCaptureDeviceInput?
    fileprivate var videoDataOutput: AVCaptureVideoDataOutput?
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    fileprivate lazy var captureSession: AVCaptureSession = AVCaptureSession()
    
    fileprivate lazy var movieFileOutput: AVCaptureMovieFileOutput = {
        let movieFileOutput = AVCaptureMovieFileOutput()
        self.captureSession.beginConfiguration()
        if self.captureSession.canAddOutput(movieFileOutput) {
            self.captureSession.addOutput(movieFileOutput)
        }
        self.captureSession.commitConfiguration()
        let connection = movieFileOutput.connection(withMediaType: AVMediaTypeVideo)
        connection?.automaticallyAdjustsVideoMirroring = true
        return movieFileOutput
    }()
    
    fileprivate var videoFileURL: URL? {
        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/capture_video.mp4"
        return URL(fileURLWithPath: filePath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化视频的输入&输出
        setupVideoInputOutput()
        
        // 初始化音频的输入&输出
        setupAudioInputOutput()
    }
    
    private func setupVideoInputOutput() {
        // 视频输入
        guard let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] else { return }
        guard let device = devices.filter({ $0.position == .front }).first else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        self.videoInput = input
        
        // 视频输出
        let output = AVCaptureVideoDataOutput()
        let queue = DispatchQueue.global()
        output.setSampleBufferDelegate(self, queue: queue)
        self.videoDataOutput = output
        
        addInputOutputToSesssion(input, output)
    }
    
    private func setupAudioInputOutput() {
        // 音频输入
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        // 音频输出
        let output = AVCaptureAudioDataOutput()
        let queue = DispatchQueue.global()
        output.setSampleBufferDelegate(self, queue: queue)
        
        addInputOutputToSesssion(input, output)
    }
    
    private func addInputOutputToSesssion(_ input: AVCaptureInput, _ output: AVCaptureOutput) {
        captureSession.beginConfiguration()
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        captureSession.commitConfiguration()
    }
}

extension ViewController {
    
    @IBAction func startCapture() {
        // 开始采集
        captureSession.startRunning()
        
        // 初始化预览图层
        setupPreviewLayer()
        
        // 写入文件(注意: 此时不会回调 captureOutput:didOutputSampleBuffer:fromConnection: 代理方法)
        //        if let fileURL = videoFileURL {
        //            movieFileOutput.startRecording(toOutputFileURL: fileURL, recordingDelegate: self)
        //        }
    }
    
    @IBAction func stopCapturing() {
        //        movieFileOutput?.stopRecording()
        
        captureSession.stopRunning()
        
        videoPreviewLayer?.removeFromSuperlayer()
    }
    
    @IBAction func rotateCamera() {
        guard let videoInput = self.videoInput else {
            return
        }
        let postion: AVCaptureDevicePosition = videoInput.device.position == .front ? .back : .front
        guard let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] else { return }
        guard let device = devices.filter({ $0.position == postion }).first else { return }
        guard let newVideoInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        captureSession.beginConfiguration()
        captureSession.removeInput(videoInput)
        if captureSession.canAddInput(newVideoInput) {
            captureSession.addInput(newVideoInput)
        }
        captureSession.commitConfiguration()
        
        self.videoInput = newVideoInput
    }
    
}

extension ViewController {
    
    fileprivate func setupPreviewLayer() {
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        self.videoPreviewLayer = previewLayer
    }
    
}

extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if videoDataOutput?.connection(withMediaType: AVMediaTypeVideo) == connection {
//            print("采集到视频数据 sampleBuffer: \(sampleBuffer)")
            print("采集到视频数据")
        } else {
//            print("采集到音频数据 sampleBuffer: \(sampleBuffer)")
            print("采集到音频数据")
        }
    }
    
}

extension ViewController : AVCaptureFileOutputRecordingDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("didStartRecordingToOutputFileAt")
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("didFinishRecordingToOutputFileAt")
    }
    
}

