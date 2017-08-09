//
//  SRChannelsControl.swift
//  SRChannelsControlDemo
//
//  Created by 郭伟林 on 2017/8/8.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class SRChannelsControl: UIView {

    // MARK: - 属性
    fileprivate var titles: [String]
    fileprivate var titleStyle: SRChannelsTitleStyle
    fileprivate var childVCs: [UIViewController]
    fileprivate var parentVC: UIViewController

    // MARK: - 构造方法
    init(frame: CGRect, titles: [String], titleStyle: SRChannelsTitleStyle, childVCs: [UIViewController], parentVC: UIViewController) {
        
        self.titles = titles
        self.titleStyle = titleStyle
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SRChannelsControl {
    
    fileprivate func setupUI() {
        
        // 1.SRChannelsTitle
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleHeight)
        let channelsTitle = SRChannelsTitle(frame: titleFrame, titles: titles, style: titleStyle)
        addSubview(channelsTitle)
        
        // 2.SRChannelsContent
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: frame.height - titleFrame.height)
        let channelsContent = SRChannelsContent(frame: contentFrame, childVCs: childVCs, parentVC: parentVC)
        addSubview(channelsContent)
        
        // 3.delegate
        channelsTitle.delegate = channelsContent
        channelsContent.delegate = channelsTitle
    }
    
}

