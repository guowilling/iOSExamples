//
//  SRLiveGiftChannelView.swift
//  SRLiveGiftViewDemo
//
//  Created by Willing Guo on 2017/9/11.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

enum SRLiveGiftChannelViewState {
    case idle
    case animating
    case staying
    case disappearing
}

class SRLiveGiftChannelView: UIView {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var giftDescribeLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var giftDigitalLabel: SRLiveGiftDigitalLabel!
    
    fileprivate var currentNumber: Int = 0
    fileprivate var cachedNumber: Int = 0
    
    var state: SRLiveGiftChannelViewState = .idle
    
    var lifecycleCompletion: ((SRLiveGiftChannelView) -> Void)?
    
    var giftModel: SRLiveGiftModel? {
        didSet {
            guard let giftModel = giftModel else {
                return
            }
            iconImageView.image = UIImage(named: giftModel.iconURLString)
            senderNameLabel.text = giftModel.senderName
            giftDescribeLabel.text = "送出礼物:【\(giftModel.giftName)】"
            giftImageView.image = UIImage(named: giftModel.giftURLString)
            
            performShowing()
        }
    }
}

extension SRLiveGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        
        iconImageView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.white.cgColor
    }
}

extension SRLiveGiftChannelView {
    
    class func loadFromNib() -> SRLiveGiftChannelView {
        return Bundle.main.loadNibNamed("SRLiveGiftChannelView", owner: nil, options: nil)?.first as! SRLiveGiftChannelView
    }
    
    func oneMoreTime() {
        if state == .staying {
            giftDigitalLabelPerformAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else {
            cachedNumber += 1
        }
    }
}

extension SRLiveGiftChannelView {
    
    fileprivate func performShowing() {
        state = .animating
        giftDigitalLabel.text = " x1 "
        giftDigitalLabel.alpha = 1.0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }, completion: { isFinished in
            self.giftDigitalLabelPerformAnimation()
        })
    }
    
    fileprivate func giftDigitalLabelPerformAnimation() {
        currentNumber += 1
        giftDigitalLabel.text = " x\(currentNumber) "
        giftDigitalLabel.performAnimation {
            if self.cachedNumber > 0 {
                self.cachedNumber -= 1
                self.giftDigitalLabelPerformAnimation()
            } else {
                self.state = .staying
                self.perform(#selector(self.performDisappearing), with: nil, afterDelay: 2.0)
            }
        }
    }
    
    @objc fileprivate func performDisappearing() {
        state = .disappearing
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }, completion: { isFinished in
            self.state = .idle
            
            self.frame.origin.x = -self.frame.width
            self.giftDigitalLabel.alpha = 0.0
            
            self.giftModel = nil
            self.currentNumber = 0
            self.cachedNumber = 0
            
            if let lifecycleCompletion = self.lifecycleCompletion {
                lifecycleCompletion(self)
            }
        })
    }
}
