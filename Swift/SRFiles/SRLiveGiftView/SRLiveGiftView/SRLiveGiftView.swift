//
//  SRLiveGiftView.swift
//  SRLiveGiftViewDemo
//
//  Created by Willing Guo on 2017/9/11.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

private let kChannelViewCount: Int = 2
private let kChannelViewHeight: CGFloat = 44
private let kChannelViewMargin: CGFloat = 10

class SRLiveGiftView: UIView {
    
    fileprivate lazy var channelViews: [SRLiveGiftChannelView] = [SRLiveGiftChannelView]()
    
    fileprivate lazy var cachedGiftModels: [SRLiveGiftModel] = [SRLiveGiftModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SRLiveGiftView {
    fileprivate func setupUI() {
        //let w: CGFloat = frame.width
        let w: CGFloat = 0
        let h: CGFloat = kChannelViewHeight
        let x: CGFloat = 0
        for i in 0..<kChannelViewCount {
            let y: CGFloat = (h + kChannelViewMargin) * CGFloat(i)
            let channelView = SRLiveGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            channelView.lifecycleCompletion = { channelView in
                guard self.cachedGiftModels.count != 0 else {
                    return
                }
                let firstGiftModel = self.cachedGiftModels.first!
                self.cachedGiftModels.removeFirst()
                channelView.giftModel = firstGiftModel
                
                for i in (0..<self.cachedGiftModels.count).reversed() {
                    let giftModel = self.cachedGiftModels[i]
                    if giftModel.isEqual(firstGiftModel) {
                        channelView.oneMoreTime()
                        self.cachedGiftModels.remove(at: i)
                    }
                }
            }
            addSubview(channelView)
            channelViews.append(channelView)
        }
    }
}

extension SRLiveGiftView {
    
    func showGift(_ giftModel: SRLiveGiftModel) {
        if let channelView = getUsingChannelView(giftModel) {
            channelView.oneMoreTime()
            return
        }
        if let channelView = getIdleChannelView() {
            channelView.giftModel = giftModel
            return
        }
        cachedGiftModels.append(giftModel)
        print(cachedGiftModels)
    }
    
    private func getUsingChannelView(_ giftModel: SRLiveGiftModel) -> SRLiveGiftChannelView? {
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .disappearing {
                return channelView
            }
        }
        return nil
    }
    
    private func getIdleChannelView() -> SRLiveGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
}
