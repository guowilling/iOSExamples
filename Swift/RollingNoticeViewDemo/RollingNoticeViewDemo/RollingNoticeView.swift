//
//  RollingNoticeView.swift
//  RollingNoticeView
//
//  Created by 郭伟林 on 2018/10/31.
//  Copyright © 2018年 BITMAIN. All rights reserved.
//

import UIKit

class RollingNoticeView: UIView {

    typealias OnClickedNoticeClosure = ((RollingNoticeView, String) -> Void)
    
    // MARK: - Public Properties
    public var onClickedClosure: OnClickedNoticeClosure?
    public var speed: CGFloat = 0.5
    
    public var attrText: NSAttributedString? {
        didSet {
            guard let text = attrText else { return }
            
            setNeedsLayout()
            layoutIfNeeded()
            
            contentLabel.attributedText = text
            
            let size = text.boundingRect(with: CGSize(width: .infinity, height: self.frame.size.height), options: .usesLineFragmentOrigin, context: nil)
            contentLabel.frame = CGRect(x: contentContainer.frame.size.width, y: 0, width: size.width, height: contentContainer.frame.size.height)
            
            startRolling()
        }
    }
    
    // MARK: - Private Properties
    private var timer: Timer?
    
    // MARK: -
    deinit {
        stopRolling()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.masksToBounds = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        iconImageView.center.y = self.frame.size.height * 0.5
        
        contentContainer.frame = CGRect(x: iconImageView.frame.maxX + 10, y: 0, width: self.frame.size.width - (iconImageView.frame.maxX + 10), height: self.frame.size.height)
    }
    
    // MARK: - Public Methods
    func setOnClickedNoticeClosure(_ closure: OnClickedNoticeClosure?) -> Void {
        self.onClickedClosure = closure
    }
    
    public func stopRolling() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    // MARK: - Private Methods
    func startRolling() {
        stopRolling()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(rollingLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    @objc private func rollingLabel() {
        contentLabel.frame.origin.x = contentLabel.frame.origin.x - (speed <= 0 ? 0.5 : speed);
        if (contentLabel.frame.maxX <= 0) {
            contentLabel.frame.origin.x = contentContainer.frame.size.width;
        }
    }
    
    @objc private func didTapAction() {
        guard let text = attrText else { return }
        self.onClickedClosure?(self, text.string)
    }
    
    // MARK: - UI
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect.zero)
        let image = UIImage(named: "home_icon_notice")
        iv.image = image
        iv.contentMode = .center
        addSubview(iv)
        return iv
    }()
    
    private lazy var contentContainer: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        addSubview(view)
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let lb = UILabel()
        contentContainer.addSubview(lb)
        return lb
    }()
}
