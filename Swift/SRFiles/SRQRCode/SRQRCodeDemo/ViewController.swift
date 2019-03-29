//
//  ViewController.swift
//  SRQRCodeDemo
//
//  Created by 郭伟林 on 2019/3/28.
//  Copyright © 2019年 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func createQRCodeBtnAction(_ sender: UIButton) {
        sender.setTitle("", for: .normal)
        let qrCodeImage = UIImage.createQRCode(size: sender.frame.width, dataStr: "Hello QRCode!")
        sender.setImage(qrCodeImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    @IBAction func scanQRCodeBtnAction(_ sender: UIButton) {
        SRQRCodeCaptureSessionManager.checkAuthorizationStatusForCamera(grantedClosure: {
            self.navigationController?.pushViewController(ScanQRCodeViewController(), animated: true)
        }) {
            let alertC = UIAlertController(
                title: "摄像头权限",
                message: "您未开启摄像头使用权限, 请先开启.",
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
    
}

