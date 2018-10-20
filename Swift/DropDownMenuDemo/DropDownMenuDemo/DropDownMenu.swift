//
//  DropDownMenu.swift
//  DropDownMenuDemo
//
//  Created by Willing Guo on 2018/10/19.
//  Copyright © 2018年 bitmain. All rights reserved.
//

import UIKit

class DropDownMenu: UIView {
    
    fileprivate let itemH: CGFloat = 44.0
    fileprivate let sreenW = UIScreen.main.bounds.size.width
    fileprivate let sreenH = UIScreen.main.bounds.size.height
    fileprivate var menuCellID = "DropDownMenuCell"
    
    var dataSource = [String]()
    
    var coverView: UIView?
    var menuTitle: DropDownMenuTitle?
    var menuTable: UITableView?
    
    var didSelectClosure: ((_ index: Int) -> Void)?
    
    init(frame: CGRect, dataSource: [String], didSelectClosure: @escaping (_ index: Int) -> Void) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.isUserInteractionEnabled = true
        
        self.dataSource = dataSource
        self.didSelectClosure = didSelectClosure
        
        setupCoverView()
        setupMenuTitle()
        setupMenuTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCoverView() {
        coverView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: sreenW, height: sreenH - self.frame.origin.y))
        coverView?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        coverView?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapCoverView)))
        coverView?.alpha = 0
        addSubview(coverView!)
    }
    
    func setupMenuTitle() {
        menuTitle = DropDownMenuTitle.init(frame: CGRect.init(x: 0, y: 0, width: sreenW, height: itemH), titleText: dataSource.first!)
        menuTitle?.tapGestureClosure = { (selected) -> Void in
            if selected {
                self.menuTitle?.isSelected = true
                self.showMenuTable()
            } else {
                self.dismissMenuTable()
            }
        }
        self.addSubview(menuTitle!)
    }
    
    func setupMenuTable() {
        menuTable = UITableView.init(frame: CGRect.init(x: 0, y: itemH, width: sreenW, height: 1.0), style: .plain)
        menuTable?.delegate = self
        menuTable?.dataSource = self
        menuTable?.backgroundColor = UIColor.white
        menuTable?.register(UITableViewCell.self, forCellReuseIdentifier: menuCellID)
        menuTable?.rowHeight = itemH
        self.addSubview(menuTable!)
    }
    
    @objc func didTapCoverView() {
        menuTitle?.isSelected = false
        self.dismissMenuTable()
    }
}

extension DropDownMenu: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellID, for: indexPath) as UITableViewCell
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.textLabel?.text == menuTitle?.titleText {
            return
        }
        menuTitle?.titleText = cell?.textLabel?.text
        menuTitle?.isSelected = false
        
        self.dismissMenuTable()
        
        if self.didSelectClosure != nil {
            self.didSelectClosure!(indexPath.row)
        }
    }
}

extension DropDownMenu {
    fileprivate func showMenuTable() {
        UIView.animate(withDuration: 0.2, animations: {
            self.coverView?.alpha = 1
            self.menuTable?.frame = CGRect.init(x: 0,
                                                y: self.itemH,
                                                width: self.sreenW,
                                                height: (CGFloat(self.dataSource.count) * self.itemH) > 375.0 ? 375.0 : (CGFloat(self.dataSource.count) * self.itemH))
        })
    }
    
    fileprivate func dismissMenuTable() {
        UIView.animate(withDuration: 0.2, animations: {
            self.coverView?.alpha = 0
            self.menuTable?.frame = CGRect.init(x: 0,
                                                y: self.itemH,
                                                width: self.sreenW,
                                                height: 1.0)
        })
    }
}

extension DropDownMenu {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        if hitView == nil {
            for subView in self.subviews {
                let cPoint = subView.convert(point, from: self)
                if subView.bounds.contains(cPoint) {
                    hitView = subView
                }
            }
        }
        if hitView?.alpha == 0 {
            return super.hitTest(point, with: event)
        }
        return hitView
    }
}

