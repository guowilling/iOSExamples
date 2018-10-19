//
//  DropDownMenuTitle.swift
//  DropDownMenuDemo
//
//  Created by Willing Guo on 2018/10/19.
//  Copyright © 2018年 bitmain. All rights reserved.
//

import UIKit
import SnapKit

typealias TapGestureClosure = (_ selected: Bool) -> Void

class DropDownMenuTitle: UIView {

    public var titleText: String? {
        didSet {
            self.titleWidth = self.textWidth(text: self.titleText!,
                                             font: UIFont.systemFont(ofSize: 20),
                                             height: 28) + 2
            titleLabel.text = self.titleText
            setupConstraints()
        }
    }
    
    var tapGestureClosure: TapGestureClosure?
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.2, animations: {
                    self.arrowIcon.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.arrowIcon.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = self.titleText
        return label
    }()
    
    private var titleWidth: CGFloat?
    
    private lazy var arrowIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage.init(named:"arrow_down")
        return icon
    }()
    
    init(frame: CGRect, titleText: String) {
        super.init(frame: frame)
        
        self.titleText = titleText
        self.titleWidth = self.textWidth(text: self.titleText!,
                                         font: UIFont.systemFont(ofSize: 20),
                                         height: 28) + 2
        
        self.setupUI()
        self.setupConstraints()
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        addSubview(arrowIcon)
    }
    
    func setupConstraints() {
        titleLabel.snp.removeConstraints()
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-15 * 0.5)
            make.centerY.equalTo(self)
            make.width.equalTo(titleWidth!)
            make.height.equalTo(self)
        }
        
        arrowIcon.snp.removeConstraints()
        arrowIcon.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
    
    @objc func tapGestureAction() {
        self.isSelected = !self.isSelected
        if (self.tapGestureClosure != nil) {
            self.tapGestureClosure!(self.isSelected)
        }
    }
    
    func textWidth(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: 999, height: height),
                                 options: .usesLineFragmentOrigin,
                                 attributes: [NSAttributedStringKey.font: font],
                                 context: nil).size.width
    }
}
