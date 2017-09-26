//
//  EmitterLayerAnimationable.swift
//  CAEmitterLayerAnimation
//
//  Created by 郭伟林 on 2017/8/28.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

protocol EmitterLayerAnimationable {
    
}

extension EmitterLayerAnimationable where Self: UIViewController {
    
    func startEmittering(_ point : CGPoint) {
        // 创建发射器
        let emitter = CAEmitterLayer()
        // 设置发射器的位置
        emitter.emitterPosition = point
        // 开启三维效果
        emitter.preservesDepth = true
        var cells = [CAEmitterCell]()
        for i in 0..<10 { // 创建粒子并设置粒子的相关属性
            let cell = CAEmitterCell()
            // 粒子速度
            cell.velocity = 150
            cell.velocityRange = 100
            
            // 粒子大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            // 粒子方向
            cell.emissionLongitude = CGFloat(-Double.pi / 2)
            cell.emissionRange = CGFloat(Double.pi / 2 / 6)
            
            // 粒子存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            // 粒子旋转
            cell.spin = CGFloat(Double.pi / 2)
            cell.spinRange = CGFloat(Double.pi / 2 / 2)
            
            // 每秒弹出的粒子个数
            cell.birthRate = 2
            
            // 粒子展示的图片
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            
            cells.append(cell)
        }
        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)
    }
    
    func stopEmittering() {
//        for layer in view.layer.sublayers! {
//            if layer.isKind(of: CAEmitterLayer.self) {
//                layer.removeFromSuperlayer()
//            }
//        }
        view.layer.sublayers?.filter({ $0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}
