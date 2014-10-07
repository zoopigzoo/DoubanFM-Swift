//
//  PlayUIView.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-9-22.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class PlayUIView : UIView {
    var num: NSInteger = 4
    var items: Array<CAShapeLayer> = []
    var duration: Double = 1.0
    
    func initVerticlePath(height:CGFloat, wholeheight: CGFloat) -> CGPath{
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, wholeheight)
        CGPathAddLineToPoint(path, nil, 0, wholeheight + height)
        
        return path
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addAnimation() {
        var avgDuration = self.duration / Double(num)

        var durnow = 0.0
        var idx: CGFloat = 0

        for layer in self.layer.sublayers {
            layer.removeAnimationForKey("scale-layer")
            
            var animation = CABasicAnimation(keyPath:"transform.scale.y")
            animation.duration = self.duration; // 动画持续时间
            animation.repeatCount = Float.infinity; // 重复次数
            animation.autoreverses = true; // 动画结束时执行逆动画
            animation.fromValue =  Double(1.0); // 开始时的倍率
            animation.toValue = Double(num) // 结束时的倍率
            animation.beginTime = CACurrentMediaTime() + durnow;
            layer.addAnimation(animation, forKey: "scale-layer")
            durnow = durnow + avgDuration
            idx = idx + 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        var index:CGFloat = 0;
        var width = frame.width
        var height = frame.height
        var avgwidth = width / CGFloat(num)
        var avgheight = height / CGFloat(num)
        var avgDuration = self.duration / Double(num)
        
        for index in 0...self.num-1 {
            var shape = CAShapeLayer()
            shape.path = self.initVerticlePath(avgheight, wholeheight: height)
            items.append(shape)
        }
        
        let mainColor:UIColor = UIColor(red: 100 / 255.0, green: 188 / 255.0, blue: 124 / 255.0, alpha: 1.00)
        
        NSLog("height:\(height)")

        index = 0
        var durnow = 0.0
        var idx: CGFloat = 0
        for layer in items {
            layer.fillColor = nil
            layer.strokeColor = mainColor.CGColor
            layer.lineWidth = 2
            layer.miterLimit = 2
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            
            let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 2, kCGLineCapRound, kCGLineJoinMiter, 2)
            
            layer.bounds = CGPathGetPathBoundingBox(strokingPath)
            layer.position = CGPointMake(index, 0.0)
            layer.anchorPoint = CGPointMake(0.0, 0.0)
            layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 1.0, 0.0, 0.0);
            
            self.layer.addSublayer(layer)
            
            index = index + avgwidth
            durnow = durnow + avgDuration
            idx = idx + 1
        }
        
        self.addAnimation()
    }
}

extension CALayer {
    func ocb_applyAnimation(animation: CABasicAnimation) {
        let copy = animation.copy() as CABasicAnimation
        
        if copy.fromValue == nil {
            copy.fromValue = self.presentationLayer().valueForKeyPath(copy.keyPath)
        }
        
        self.addAnimation(copy, forKey: copy.keyPath)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath)
    }
}
