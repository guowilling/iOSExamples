//
//  SRLiveGiftDigitalLabel.swift
//  SRLiveGiftViewDemo
//
//  Created by 郭伟林 on 2017/9/11.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class SRLiveGiftDigitalLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let graphicsContext = UIGraphicsGetCurrentContext()
        
        graphicsContext?.setLineWidth(5)
        graphicsContext?.setLineJoin(.round)
        graphicsContext?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        graphicsContext?.setTextDrawingMode(.fill)
        textColor = UIColor.white
        super.drawText(in: rect)
    }
    
    func performAnimation(_ completion : @escaping () -> ()) {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }, completion: { isFinished in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (isFinished) in
                completion()
            })
        })
    }

}
