//
//  SRChannelsContent.swift
//  SRChannelsControlDemo
//
//  Created by 郭伟林 on 2017/8/8.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

protocol SRChannelsContentDelegate : class {
    
//    func channelsContent(_ channelsContent: SRChannelsContent, scrollToIndex toIndex: Int, progress: CGFloat)
    func channelsContent(_ channelsContent: SRChannelsContent, scrollFromIndex fromIndex: Int, toIndex:Int, progress: CGFloat)
    func channelsContent(_ channelsContent: SRChannelsContent, didEndScrollAtIndex atIndex : Int)
    
}

fileprivate let kContentCellID = "kContentCellID"

class SRChannelsContent: UIView {
    
    weak var delegate: SRChannelsContentDelegate?
    
    fileprivate var childVCs: [UIViewController]
    fileprivate var parentVC: UIViewController
    
    fileprivate lazy var startOffsetX: CGFloat = 0
    fileprivate lazy var disableScroll: Bool = false
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SRChannelsContent {
    
    fileprivate func setupUI() {
        for vc in childVCs {
            parentVC.addChildViewController(vc)
        }
        addSubview(collectionView)
    }
    
}


extension SRChannelsContent: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let vc = childVCs[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        return cell
    }
    
}


extension SRChannelsContent: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        disableScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let floorIndex = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
        if floorIndex < 0 || floorIndex > childVCs.count - 1 {
            return;
        }
        var progress = scrollView.contentOffset.x / scrollView.frame.size.width - CGFloat(floorIndex)
        var fromIndex = 0
        var toIndex = 0
        if scrollView.contentOffset.x > startOffsetX {
            fromIndex = floorIndex;
            toIndex = min(childVCs.count - 1, fromIndex + 1);
            if (fromIndex == toIndex && toIndex == childVCs.count - 1) {
                fromIndex = childVCs.count - 2;
                progress = 1.0;
            }
        } else {
            toIndex = floorIndex;
            fromIndex = min(childVCs.count - 1, toIndex + 1);
            progress = 1.0 - progress;
        }
        delegate?.channelsContent(self, scrollFromIndex: fromIndex, toIndex: toIndex, progress: progress)
        
//        if scrollView.contentOffset.x == startOffsetX || disableScroll {
//            return
//        }
//        var toIndex: Int = 0
//        var progress: CGFloat = 0
//        if scrollView.contentOffset.x > startOffsetX {
//            toIndex = Int(startOffsetX / scrollView.bounds.width) + 1
//            if toIndex >= childVCs.count {
//                toIndex = childVCs.count - 1
//            }
//            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
//        } else {
//            toIndex = Int(startOffsetX / scrollView.bounds.width) - 1
//            if toIndex < 0 {
//                toIndex = 0
//            }
//            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
//        }
//        delegate?.channelsContent(self, scrollToIndex: toIndex, progress: progress)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewEndScroll()
        } else {
//            scrollView.isScrollEnabled = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewEndScroll()
//        scrollView.isScrollEnabled = true
    }
    
    private func collectionViewEndScroll() {
        let atIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.channelsContent(self, didEndScrollAtIndex: atIndex)
    }

}


extension SRChannelsContent: SRChannelsTitleDeleate {
    
    func channelsTitle(_ channelsTitle: SRChannelsTitle, didSelectIndex index: Int) {
        disableScroll = true
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
}

