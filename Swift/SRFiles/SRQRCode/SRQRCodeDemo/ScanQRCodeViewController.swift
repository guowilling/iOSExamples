
import UIKit

class ScanQRCodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var sessionManager: SRQRCodeCaptureSessionManager!
    var displayLink: CADisplayLink!
    
    let scanBorderIV: UIImageView = UIImageView()
    let scanLineIV: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
        sessionManager = SRQRCodeCaptureSessionManager(captureType: .qrCode, scanRect: CGRect.null, completion: { (result) in
            if let str = result {
                self.showResult(result: str)
            }
        })
        sessionManager.showPreviewLayerIn(view: view)
        sessionManager.isPlaySound = true
        
        setupScanUI()
        
        displayLink = CADisplayLink(target: self, selector: #selector(scanAnimation))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        sessionManager.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        displayLink.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
        sessionManager.stopRunning()
    }
    
    private func setupNavBar() {
        navigationItem.title = "扫描二维码"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(showPhotoAlbum))
    }
    
    private func setupScanUI() {
        scanBorderIV.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        scanBorderIV.center = view.center
        scanBorderIV.image = UIImage(named: "qrcode_scan_border")
        scanBorderIV.contentMode = .scaleAspectFit
        view.addSubview(scanBorderIV)
        
        scanLineIV.frame = CGRect(x: 0, y: 0, width: scanBorderIV.frame.width, height: 12)
        scanLineIV.image = UIImage(named: "qrcode_scan_line")
        scanLineIV.contentMode = .scaleAspectFit
        scanBorderIV.addSubview(scanLineIV)
        
        let flashlightBtn = UIButton(type: .custom)
        flashlightBtn.setImage(UIImage(named: "qrcode_flashlight_off"), for: .normal)
        flashlightBtn.frame = CGRect(x: 0, y: scanBorderIV.frame.maxY + 20, width: 33, height: 33)
        flashlightBtn.center.x = scanBorderIV.center.x
        flashlightBtn.addTarget(self, action: #selector(flashlightBtnAction(_:)), for: .touchUpInside)
        view.addSubview(flashlightBtn)
    }
    
    @objc private func flashlightBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sessionManager.turnTorch(state: sender.isSelected)
        if sender.isSelected {
            sender.setImage(UIImage(named: "qrcode_flashlight_on"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "qrcode_flashlight_off"), for: .normal)
        }
    }
    
    @objc private func showPhotoAlbum() {
        SRQRCodeCaptureSessionManager.checkAuthorizationStatusForPhotoLibrary(granted: {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }) {
            let alertC = UIAlertController(
                title: "相册权限",
                message: "您未开启相册使用权限, 请先开启.",
                preferredStyle: UIAlertController.Style.alert)
            let action1 = UIAlertAction(title: "取消", style: UIAlertAction.Style.default)
            let action2 = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            })
            alertC.addAction(action1)
            alertC.addAction(action2)
            self.present(alertC, animated: true, completion: nil)
        }
    }
    
    @objc private func scanAnimation() {
        scanLineIV.frame.origin.y += 1.5
        if scanLineIV.frame.maxY >= scanBorderIV.frame.height {
            scanLineIV.frame.origin.y = 0
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            self.sessionManager.startRunning()
            self.sessionManager.scanPhoto(image: info[.originalImage] as! UIImage, completion: { (result) in
                if let str = result {
                    self.showResult(result: str)
                }else {
                    self.showResult(result: "未识别到二维码")
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        sessionManager.startRunning()
        dismiss(animated: true, completion: nil)
    }
    
    private func showResult(result: String) {
        let alertC = UIAlertController(
            title: "扫描结果",
            message: result,
            preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
            self.sessionManager.startRunning()
        })
        alertC.addAction(action)
        self.present(alertC, animated: true, completion: nil)
    }
}
