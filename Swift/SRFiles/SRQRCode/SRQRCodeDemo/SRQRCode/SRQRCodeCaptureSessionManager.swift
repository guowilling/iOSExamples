
import UIKit
import Photos

typealias completionClosure = (String?) -> Void
typealias GrantedClosure = () -> Void
typealias DeniedClosure = () -> Void

enum SRQRCodeCaptureType {
    case qrCode
    case barCode
    case both
    func supportTypes() -> [AVMetadataObject.ObjectType] {
        switch self {
        case .qrCode:
            return [AVMetadataObject.ObjectType.qr]
        case .barCode:
            return [AVMetadataObject.ObjectType.dataMatrix,
                    AVMetadataObject.ObjectType.itf14,
                    AVMetadataObject.ObjectType.interleaved2of5,
                    AVMetadataObject.ObjectType.aztec,
                    AVMetadataObject.ObjectType.pdf417,
                    AVMetadataObject.ObjectType.code128,
                    AVMetadataObject.ObjectType.code93,
                    AVMetadataObject.ObjectType.ean8,
                    AVMetadataObject.ObjectType.ean13,
                    AVMetadataObject.ObjectType.code39Mod43,
                    AVMetadataObject.ObjectType.code39,
                    AVMetadataObject.ObjectType.upce]
        case .both:
            return [AVMetadataObject.ObjectType.qr,
                    AVMetadataObject.ObjectType.dataMatrix,
                    AVMetadataObject.ObjectType.itf14,
                    AVMetadataObject.ObjectType.interleaved2of5,
                    AVMetadataObject.ObjectType.aztec,
                    AVMetadataObject.ObjectType.pdf417,
                    AVMetadataObject.ObjectType.code128,
                    AVMetadataObject.ObjectType.code93,
                    AVMetadataObject.ObjectType.ean8,
                    AVMetadataObject.ObjectType.ean13,
                    AVMetadataObject.ObjectType.code39Mod43,
                    AVMetadataObject.ObjectType.code39,
                    AVMetadataObject.ObjectType.upce]
        }
    }
}

class SRQRCodeCaptureSessionManager: AVCaptureSession, AVCaptureMetadataOutputObjectsDelegate {
    
    var isPlaySound = false
    var soundName: String?
    
    private var completion: completionClosure!
    
    private lazy var captureDevice: AVCaptureDevice? = {
       return AVCaptureDevice.default(for:.video)
    }()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: self)
    }()
    
    class func createSessionManager(captureType: SRQRCodeCaptureType, scanRect: CGRect, success: @escaping completionClosure) -> SRQRCodeCaptureSessionManager {
        return SRQRCodeCaptureSessionManager(captureType: captureType, scanRect: scanRect, completion: success);
    }
    
    convenience init(captureType: SRQRCodeCaptureType, scanRect: CGRect, completion: @escaping completionClosure) {
        self.init()
        self.completion = completion
        
        var input: AVCaptureDeviceInput?
        do {
            if let device = captureDevice {
                input = try AVCaptureDeviceInput(device: device)
            }
        } catch let error as NSError {
            print("AVCaputreDeviceError \(error)")
        }
        if let input = input {
            if canAddInput(input) {
                addInput(input)
            }
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if !scanRect.equalTo(CGRect.null) {
            output.rectOfInterest = scanRect
        }
        if canAddOutput(output) {
            addOutput(output)
        }
        output.metadataObjectTypes = captureType.supportTypes()
        
        sessionPreset = AVCaptureSession.Preset.high
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopRunning), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startRunning), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func showPreviewLayerIn(view: UIView) {
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if (metadataObjects.count > 0) {
            stopRunning()
            playSound()
            let result = metadataObjects.last as! AVMetadataMachineReadableCodeObject
            completion?(result.stringValue)
        }
    }
    
    /// 开关闪光灯
    func turnTorch(state: Bool) {
        if let device = captureDevice {
            if device.hasTorch {
                do {
                    try device.lockForConfiguration()
                } catch let error as NSError {
                    print("TorchError  \(error)")
                }
                if state {
                    device.torchMode = AVCaptureDevice.TorchMode.on
                } else {
                    device.torchMode = AVCaptureDevice.TorchMode.off
                }
                device.unlockForConfiguration()
            }
        }
    }
    
    /// 播放音效
    func playSound() {
        if isPlaySound {
            var result = "SRQRCode.bundle/sound.caf"
            if let temp = soundName, temp != ""{
                result = temp
            }
            if let urlstr = Bundle.main.path(forResource: result, ofType: nil) {
                let fileURL = NSURL(fileURLWithPath: urlstr)
                var soundID:SystemSoundID = 0;
                AudioServicesCreateSystemSoundID(fileURL, &soundID)
                AudioServicesPlaySystemSound(soundID)
            }
        }
    }
}

extension SRQRCodeCaptureSessionManager {
    /// 扫描相册图片
    func scanPhoto(image: UIImage, completion: completionClosure) {
        let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: nil,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        if detector != nil {
            let features = detector!.features(in: CIImage(cgImage: image.cgImage!))
            for feature in features {
                let result = (feature as! CIQRCodeFeature).messageString
                completion(result)
                return
            }
            completion(nil)
        } else {
            completion(nil)
        }
    }
}

extension SRQRCodeCaptureSessionManager {
    /// 检测相机权限
    class func checkAuthorizationStatusForCamera(grantedClosure: @escaping GrantedClosure, denied: DeniedClosure) {
        if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        DispatchQueue.main.async(execute: {
                            grantedClosure()
                        })
                    }
                })
            case .authorized:
                grantedClosure()
            case .denied:
                denied()
            default:
                break
            }
        }
    }
    
    /// 检测相册权限
    class func checkAuthorizationStatusForPhotoLibrary(granted: @escaping GrantedClosure, denied:DeniedClosure) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async(execute: {
                        granted()
                    })
                }
            })
        case .authorized:
            granted()
        case .denied:
            denied()
        default:
            break
        }
    }
}
