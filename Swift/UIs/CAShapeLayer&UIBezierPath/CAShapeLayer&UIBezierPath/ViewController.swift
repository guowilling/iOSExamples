//
//  ViewController.swift
//  CAShapeLayer&UIBezierPath
//
//  Created by 郭伟林 on 2019/5/28.
//  Copyright © 2019 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let quadrilateralLayer = CAShapeLayer.init()
        quadrilateralLayer.path = self.quadrilateralPath().cgPath
        quadrilateralLayer.strokeColor = UIColor.red.cgColor
        quadrilateralLayer.fillColor = UIColor.white.cgColor
        quadrilateralLayer.lineWidth = 2.5
        self.view.layer.addSublayer(quadrilateralLayer)
        
        let roundnessLayer = CAShapeLayer.init()
        roundnessLayer.path = self.roundnessPath().cgPath
        roundnessLayer.strokeColor = UIColor.red.cgColor
        roundnessLayer.fillColor = UIColor.white.cgColor
        roundnessLayer.lineWidth = 2.5
        self.view.layer.addSublayer(roundnessLayer)
        
        let ellipseLayer = CAShapeLayer.init()
        ellipseLayer.path = self.ellipsePath().cgPath
        ellipseLayer.strokeColor = UIColor.red.cgColor
        ellipseLayer.fillColor = UIColor.white.cgColor
        ellipseLayer.lineWidth = 2.5
        self.view.layer.addSublayer(ellipseLayer)

        let curveLayer1 = CAShapeLayer.init()
        curveLayer1.path = self.curvePath(controlPoints: false).cgPath
        curveLayer1.strokeColor = UIColor.red.cgColor
        curveLayer1.fillColor = UIColor.white.cgColor
        curveLayer1.lineWidth = 2.5
        self.view.layer.addSublayer(curveLayer1)
        
        let curveLayer2 = CAShapeLayer.init()
        curveLayer2.path = self.curvePath(controlPoints: true).cgPath
        curveLayer2.strokeColor = UIColor.red.cgColor
        curveLayer2.fillColor = UIColor.white.cgColor
        curveLayer2.lineWidth = 2.5
        self.view.layer.addSublayer(curveLayer2)
        
        let dashLayer = CAShapeLayer.init()
        dashLayer.path = self.dashPath().cgPath
        dashLayer.strokeColor = UIColor.red.cgColor
        dashLayer.lineDashPattern = [15, 10];
        dashLayer.lineWidth = 2.5
        self.view.layer.addSublayer(dashLayer)
    }
    
    /// 绘制四边形
    func quadrilateralPath() -> UIBezierPath {
        let bezierPath = UIBezierPath.init()
        bezierPath.move(to: CGPoint.init(x: self.view.frame.width * 0.5 - 100, y: 50))
        bezierPath.addLine(to: CGPoint.init(x: self.view.frame.width * 0.5 + 100, y: 50))
        bezierPath.addLine(to: CGPoint.init(x: self.view.frame.width * 0.5 + 100, y: 250))
        bezierPath.addLine(to: CGPoint.init(x: self.view.frame.width * 0.5 - 100, y: 250))
        bezierPath.close()
        return bezierPath
    }
    
    /// 绘制圆形
    func roundnessPath() -> UIBezierPath {
        let bezierPath = UIBezierPath.init()
        bezierPath.addArc(withCenter: CGPoint.init(x: self.view.frame.width * 0.5, y: self.view.frame.height * 0.5 - 100), radius: 50, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bezierPath.stroke()
        return bezierPath
    }
    
    /// 绘制椭圆
    func ellipsePath() -> UIBezierPath {
        let bezierPath = UIBezierPath.init(ovalIn: CGRect.init(x: self.view.frame.width * 0.5 - 100, y: self.view.frame.height * 0.5 - 25, width: 200, height: 100))
        return bezierPath
    }
    
    /// 绘制贝塞尔曲线
    func curvePath(controlPoints: Bool) -> UIBezierPath {
        let bezierPath = UIBezierPath.init()
        if controlPoints {
            bezierPath.move(to: CGPoint.init(x: self.view.frame.width * 0.5 - 150, y: self.view.frame.height * 0.5 + 250))
            bezierPath.addCurve(
                to: CGPoint.init(x: self.view.frame.width * 0.5 + 150, y: self.view.frame.height * 0.5 + 250),
                controlPoint1: CGPoint.init(x: self.view.frame.width * 0.5 - 50, y: self.view.frame.height * 0.5 + 150),
                controlPoint2: CGPoint.init(x: self.view.frame.width * 0.5 + 50, y: self.view.frame.height * 0.5 + 350)
            )
        } else {
            bezierPath.move(to: CGPoint.init(x: self.view.frame.width * 0.5 - 150, y: self.view.frame.height * 0.5 + 150))
            bezierPath.addQuadCurve(
                to: CGPoint.init(x: self.view.frame.width * 0.5 + 150, y: self.view.frame.height * 0.5 + 150),
                controlPoint: CGPoint.init(x: self.view.frame.width * 0.5, y: self.view.frame.height * 0.5 + 50)
            )
        }
        bezierPath.stroke()
        return bezierPath
    }
    
    /// 绘制虚线
    func dashPath() -> UIBezierPath {
        let bezierPath = UIBezierPath.init()
        bezierPath.move(to: CGPoint.init(x: self.view.frame.width * 0.5 - 150, y: self.view.frame.height * 0.5 + 350))
        bezierPath.addLine(to: CGPoint.init(x: self.view.frame.width * 0.5 + 150, y: self.view.frame.height * 0.5 + 350))
        return bezierPath
    }
}

extension ViewController {
    
    /// CAShapeLayer 的介绍
    func introduceCAShapeLayer() -> Void {
        // 初始化
        var shapeLayer: CAShapeLayer!
        shapeLayer = CAShapeLayer()
        shapeLayer = CAShapeLayer.init()
        shapeLayer = CAShapeLayer.init(coder: NSCoder.init())
        shapeLayer = CAShapeLayer.init(layer: self.view.layer)
        
        // 添加路径
        shapeLayer?.path = UIBezierPath().cgPath
        
        // 路径填充颜色
        shapeLayer?.fillColor = UIColor.red.cgColor
        
        // 路径填充规则
        shapeLayer?.fillRule = CAShapeLayerFillRule(rawValue: "even-odd") // "even-zero"
        
        // 路径的颜色
        shapeLayer?.strokeColor = UIColor.gray.cgColor
        
        // 路径开始绘制的进度百分比
        shapeLayer?.strokeStart = 0.2
        
        // 路径结束绘制的进度百分比
        shapeLayer?.strokeEnd = 0.8
        
        // 路径的宽度
        shapeLayer?.lineWidth =  6
        
        // 路径尾端的形状 'butt'/'square'(矩形), `round'（半圆形）, `square'（矩形）
        shapeLayer?.lineCap = CAShapeLayerLineCap(rawValue: "butt")
        
        // 路径结合处的形状 'miter'(切角), `round'（圆弧）, `bevel'（正切角）
        shapeLayer?.lineJoin = CAShapeLayerLineJoin(rawValue: "miter")
        
        // 绘制虚线的起始偏差值
        shapeLayer?.lineDashPhase = 10
        
        // 绘制虚线的间隔值
        shapeLayer?.lineDashPattern = [10, 20]
    }
    
    /// UIBezierPath 的介绍
    func introduceiUIBezierPath(rect: CGRect) -> Void {
        // 初始化
        var bezierPath: UIBezierPath!
        bezierPath = UIBezierPath.init()
        bezierPath = UIBezierPath.init(rect: rect)
        bezierPath = UIBezierPath.init(coder: NSCoder.init())
        bezierPath = UIBezierPath.init(cgPath: CGPath.init(rect: rect, transform: UnsafePointer.init(bitPattern: 2)))
        
        // 椭圆路径
        bezierPath = UIBezierPath.init(ovalIn: rect)
        
        // 四边形带切记的路径
        bezierPath = UIBezierPath.init(roundedRect: rect, cornerRadius: 2)
        
        // 圆形路径
        bezierPath = UIBezierPath.init(arcCenter: CGPoint.init(x: 100, y: 100), radius: 30, startAngle: 0, endAngle: .pi, clockwise: true)
        
        // 移动起始点
        bezierPath.move(to: CGPoint.zero)
        
        // 添加路线点
        bezierPath.addLine(to: CGPoint.zero)
        
        // 绘制单点控制曲线
        bezierPath.addQuadCurve(to: CGPoint.zero, controlPoint: CGPoint.zero)
        
        // 绘制双点控制曲线
        bezierPath.addCurve(to: CGPoint.zero, controlPoint1: CGPoint.zero, controlPoint2: CGPoint.zero)
        
        // 绘制圆形路径
        bezierPath.addArc(withCenter: CGPoint.zero, radius: 30, startAngle: 0, endAngle: .pi, clockwise: true)
        
        // 追加路径
        bezierPath.append(bezierPath)
        
        // 移除路径上的所有点
        bezierPath.removeAllPoints()
        
        // 关闭路径
        bezierPath.close()
        
        // 修改路径
        bezierPath = bezierPath.reversing()
        
        // 转化路径
        bezierPath.apply(CGAffineTransform.identity)
        
        // 路径的宽度
        bezierPath.lineWidth = 5
        
        // 切角
        bezierPath.miterLimit = 6
        
        // 精度
        bezierPath.flatness = 0.6
        
        // 路径头部形状
        bezierPath.lineCapStyle = .butt
        
        // 路径结合处的形状
        bezierPath.lineJoinStyle = .bevel
        
        // 路径填充规则和深度
        bezierPath.fill(with: .colorDodge, alpha: 1.0)
        // 填充路径
        bezierPath.fill()
        
        // 路径闭合规则和透明度
        bezierPath.stroke(with: .colorDodge, alpha: 1)
        // 闭合路径
        bezierPath.stroke()
        
        let isEmpty = bezierPath.isEmpty
        print(isEmpty)
        
        let currentPoint = bezierPath.currentPoint
        print(currentPoint)
        
        let bounds = bezierPath.bounds
        print(bounds)
        
        let isContains = bezierPath.contains(CGPoint.zero)
        print(isContains)
        
        bezierPath.usesEvenOddFillRule = false
    }
}
