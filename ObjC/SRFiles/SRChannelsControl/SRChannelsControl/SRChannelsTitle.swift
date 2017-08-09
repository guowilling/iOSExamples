//
//  SRChannelsTitle.swift
//  SRChannelsControlDemo
//
//  Created by 郭伟林 on 2017/8/8.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

protocol SRChannelsTitleDeleate : class {
    
    func channelsTitle(_ channelsTitle: SRChannelsTitle, didSelectIndex index: Int)
    
}

class SRChannelsTitle: UIView {

    weak var delegate: SRChannelsTitleDeleate?
    
    fileprivate var titles: [String]
    fileprivate var style: SRChannelsTitleStyle
    fileprivate var currentIndex: Int = 0
    
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        return bottomLine
    }()
    
    fileprivate lazy var slider: UIView = {
        let slider = UIView()
        slider.backgroundColor = self.style.sliderColor
        slider.alpha = self.style.sliderAlpha
        return slider
    }()
    
    init(frame: CGRect, titles: [String], style: SRChannelsTitleStyle) {
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SRChannelsTitle {
    
    fileprivate func setupUI() {

        addSubview(scrollView)
        
        setupTitleLabels()
        
        setupTitleLabelsFrame()
        
        setupBottomLine()
        
        setupSlider()
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.font = style.titleFont
            titleLabel.textColor = i == 0 ? style.titleSelectdColor : style.titleNormalColor
            titleLabel.textAlignment = .center
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTapTitleLabel(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    private func setupTitleLabelsFrame() {
        let count = titles.count
        for (i, label) in titleLabels.enumerated() {
            var x: CGFloat = 0
            let y: CGFloat = 0
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            if !style.isScrollEnabled {
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            } else {
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0),
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [NSFontAttributeName: style.titleFont],
                                                         context: nil).width
                if i == 0 {
                    x = style.titleMargin * 0.5
                } else {
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.titleMargin
                }
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            if style.isTitleScaling && i == 0 {
                label.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
            }
        }
        
        if style.isScrollEnabled {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setupBottomLine() {
        guard style.isBottomLineDisplayed else {
            return
        }
        bottomLine.frame.origin.x = titleLabels.first!.frame.origin.x
        bottomLine.frame.origin.y = bounds.height - style.bottomLineHeight
        bottomLine.frame.size.width = titleLabels.first!.bounds.width
        scrollView.addSubview(bottomLine)
    }
    
    private func setupSlider() {
        guard style.isSliderDisplayed else {
            return
        }
        var coverW: CGFloat = 0.0
        if style.isScrollEnabled {
            coverW = titleLabels.first!.frame.width + style.titleMargin
        } else {
            coverW = titleLabels.first!.frame.width - 2 * style.sliderInset
        }
        let coverH: CGFloat = style.sliderHeight
        slider.bounds = CGRect(x: 0, y: 0, width: coverW, height: coverH)
        slider.center = titleLabels.first!.center
        slider.layer.cornerRadius = style.sliderHeight * 0.5
        slider.layer.masksToBounds = true
        scrollView.addSubview(slider)
    }
}


extension SRChannelsTitle {
    
    @objc fileprivate func didTapTitleLabel(_ tapGes : UITapGestureRecognizer) {
        guard let currentLabel = tapGes.view as? UILabel else {
            return
        }
        
        if currentIndex == currentLabel.tag {
            return
        }
        
        adjustPosition(currentLabel)
        
        let lastLabel = titleLabels[currentIndex]
        lastLabel.textColor = style.titleNormalColor
        currentLabel.textColor = style.titleSelectdColor
        currentIndex = currentLabel.tag
        
        if style.isBottomLineDisplayed {
            bottomLine.frame.origin.x = currentLabel.frame.origin.x
            bottomLine.frame.size.width = currentLabel.frame.width
        }
        
        if style.isTitleScaling {
            currentLabel.transform = lastLabel.transform
            lastLabel.transform = CGAffineTransform.identity
        }
        
        if style.isSliderDisplayed {
            let coverW = style.isScrollEnabled ? (currentLabel.frame.width + style.titleMargin) : (currentLabel.frame.width - 2 * style.sliderInset)
            slider.frame.size.width = coverW
            slider.center = currentLabel.center
        }
        
        delegate?.channelsTitle(self, didSelectIndex: currentIndex)
    }
    
}


extension SRChannelsTitle {
    
    fileprivate func adjustPosition(_ newLabel : UILabel) {
        guard style.isScrollEnabled else {
            return
        }
        var offsetX = newLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
}


extension SRChannelsTitle: SRChannelsContentDelegate {
    
    func channelsContent(_ channelsContent: SRChannelsContent, scrollFromIndex fromIndex: Int, toIndex: Int, progress: CGFloat) {
        let lastLabel = titleLabels[fromIndex]
        let toLabel = titleLabels[toIndex]
        
        let normalRGB = getGRBValue(style.titleNormalColor)
        let selectedRGB = getGRBValue(style.titleSelectdColor)
        let deltaRGB = (selectedRGB.0 - normalRGB.0,
                        selectedRGB.1 - normalRGB.1,
                        selectedRGB.2 - normalRGB.2)
        lastLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress,
                                      g: selectedRGB.1 - deltaRGB.1 * progress,
                                      b: selectedRGB.2 - deltaRGB.2 * progress)
        toLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress,
                                    g: normalRGB.1 + deltaRGB.1 * progress,
                                    b: normalRGB.2 + deltaRGB.2 * progress)
        
        if style.isBottomLineDisplayed {
            let deltaX = toLabel.frame.origin.x - lastLabel.frame.origin.x
            let deltaW = toLabel.frame.width - lastLabel.frame.width
            bottomLine.frame.origin.x = lastLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = lastLabel.frame.width + deltaW * progress
        }
        
        if style.isTitleScaling {
            let deltaScale = style.scaleRange - 1.0
            lastLabel.transform = CGAffineTransform(scaleX: style.scaleRange - deltaScale * progress, y: style.scaleRange - deltaScale * progress)
            toLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScale * progress, y: 1.0 + deltaScale * progress)
        }
        
        if style.isSliderDisplayed {
            let lastW = style.isScrollEnabled ? (lastLabel.frame.width + style.titleMargin) : (lastLabel.frame.width - 2 * style.sliderInset)
            let toW = style.isScrollEnabled ? (toLabel.frame.width + style.titleMargin) : (toLabel.frame.width - 2 * style.sliderInset)
            let deltaW = toW - lastW
            let deltaX = toLabel.center.x - lastLabel.center.x
            slider.frame.size.width = lastW + deltaW * progress
            slider.center.x = lastLabel.center.x + deltaX * progress
        }
    }

    
//    func channelsContent(_ channelsContent: SRChannelsContent, scrollToIndex toIndex: Int, progress: CGFloat) {
//        let lastLabel = titleLabels[currentIndex]
//        let toLabel = titleLabels[toIndex]
//        
//        let normalRGB = getGRBValue(style.titleNormalColor)
//        let selectedRGB = getGRBValue(style.titleSelectdColor)
//        let deltaRGB = (selectedRGB.0 - normalRGB.0,
//                        selectedRGB.1 - normalRGB.1,
//                        selectedRGB.2 - normalRGB.2)
//        lastLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress,
//                                      g: selectedRGB.1 - deltaRGB.1 * progress,
//                                      b: selectedRGB.2 - deltaRGB.2 * progress)
//        toLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress,
//                                    g: normalRGB.1 + deltaRGB.1 * progress,
//                                    b: normalRGB.2 + deltaRGB.2 * progress)
//        
//        if style.isBottomLineDisplayed {
//            let deltaX = toLabel.frame.origin.x - lastLabel.frame.origin.x
//            let deltaW = toLabel.frame.width - lastLabel.frame.width
//            bottomLine.frame.origin.x = lastLabel.frame.origin.x + deltaX * progress
//            bottomLine.frame.size.width = lastLabel.frame.width + deltaW * progress
//        }
//
//        if style.isTitleScaling {
//            let deltaScale = style.scaleRange - 1.0
//            lastLabel.transform = CGAffineTransform(scaleX: style.scaleRange - deltaScale * progress, y: style.scaleRange - deltaScale * progress)
//            toLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScale * progress, y: 1.0 + deltaScale * progress)
//        }
//        
//        if style.isSliderDisplayed {
//            let lastW = style.isScrollEnabled ? (lastLabel.frame.width + style.titleMargin) : (lastLabel.frame.width - 2 * style.sliderInset)
//            let toW = style.isScrollEnabled ? (toLabel.frame.width + style.titleMargin) : (toLabel.frame.width - 2 * style.sliderInset)
//            let deltaW = toW - lastW
//            let deltaX = toLabel.center.x - lastLabel.center.x
//            slider.frame.size.width = lastW + deltaW * progress
//            slider.center.x = lastLabel.center.x + deltaX * progress
//        }
//    }
    
    func channelsContent(_ channelsContent: SRChannelsContent, didEndScrollAtIndex atIndex: Int) {
        let lastLabel = titleLabels[currentIndex]
        let atLabel = titleLabels[atIndex]
        lastLabel.textColor = style.titleNormalColor
        atLabel.textColor = style.titleSelectdColor
        
        currentIndex = atIndex
        
        adjustPosition(atLabel)
    }

    private func getGRBValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("Must RGB Color!")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
    
}

