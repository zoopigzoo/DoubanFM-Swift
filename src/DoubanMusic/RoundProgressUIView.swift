//
//  RoundProgressUIView.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-10-3.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

class RoundProgressUIView: UIView {
    var progress:Float = 0.0
    var progressWidthRatio: CGFloat = 0.13
    var progressColor: UIColor = UIColor(red: 100/255.0, green: 188/255.0, blue: 124/255.0, alpha: 1.0)
    var progresslayer: CAShapeLayer?
    var orgframeradius: CGFloat?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup(self.frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup(frame)
    }
    
    override init() {
        super.init()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setProgress(p: Float) {
        if(p < 0) {
            progress = 0.0
        } else if(p > 1.0) {
            progress = 1.0
        } else {
            progress = p
        }
        
        if(self.progressWidthRatio > 0) {
            self.progresslayer!.path = self.createPieSlice(self.orgframeradius!/2, innerRadius: self.orgframeradius!/2 - self.progressWidthRatio * self.orgframeradius!/2, progress: self.progress)
        }
    }
    
    func setProgressWidthRatio(w: CGFloat) {
        self.progressWidthRatio = w
    }
    
    func setProgressColor(c: UIColor) {
        self.progressColor = c
    }
    
    func setup(maskBounds: CGRect) {
        self.orgframeradius = self.frame.width
        
        self.contentMode = UIViewContentMode.ScaleAspectFill;
        self.clipsToBounds = true;
        
        var maskLayer:CAShapeLayer = CAShapeLayer()
        var maskPath:CGPathRef = CGPathCreateWithEllipseInRect(maskBounds, nil)
        maskLayer.bounds = maskBounds
        maskLayer.path = maskPath
        maskLayer.fillColor = self.backgroundColor?.CGColor
        
        var point:CGPoint = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2)
        maskLayer.position = point
        
        self.layer.mask = maskLayer
        
        self.progresslayer = CAShapeLayer()
        self.progresslayer!.fillColor = self.progressColor.CGColor
        self.layer.addSublayer(self.progresslayer)
    }
    
    func addMaskToBounds(maskBounds: CGRect){
        var maskLayer:CAShapeLayer = CAShapeLayer()
        var maskPath:CGPathRef = CGPathCreateWithEllipseInRect(maskBounds, nil)
        maskLayer.bounds = maskBounds
        maskLayer.path = maskPath
        maskLayer.fillColor = self.backgroundColor?.CGColor
        
        var point:CGPoint = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2)
        maskLayer.position = point
        
        self.layer.mask = maskLayer
    }
    
    func DEG2RAD(angle:CGFloat) -> CGFloat {
        let p:CGFloat=CGFloat(angle * CGFloat(M_PI))
        return CGFloat(p / 180.0)
    }
    
    func createPieSlice(radius:CGFloat, innerRadius: CGFloat, progress: Float) -> CGPath{
        let slice:CAShapeLayer = CAShapeLayer()
        
        let radiuShift: CGFloat = radius - innerRadius
        let angle:CGFloat = DEG2RAD(-90.0)
        let center:CGPoint = CGPointMake(radius, radius)
        var toAngle:CGFloat = -90.0 + CGFloat(progress) * 360
        let toAngleDeg = DEG2RAD(toAngle)
        
        let point1:CGPoint = CGPointMake(center.x, center.y - innerRadius)
        let point2:CGPoint = CGPointMake(center.x, center.y - radius)
        let pt12:CGPoint = CGPointMake(center.x, center.y - (innerRadius + radius)/2)
        let point3:CGPoint = CGPointMake(center.x + innerRadius * cos(toAngleDeg), center.y + innerRadius * sin(toAngleDeg))
        let pt34:CGPoint = CGPointMake(center.x + (radius + innerRadius) * cos(toAngleDeg)/2, center.y + (radius + innerRadius) * sin(toAngleDeg)/2)
        
        var piePath:UIBezierPath = UIBezierPath()
        piePath.moveToPoint(point1)
        piePath.addArcWithCenter(pt12, radius: (radius - innerRadius)/2, startAngle: DEG2RAD(90.0), endAngle: DEG2RAD(270.0), clockwise: true)
        piePath.addArcWithCenter(center, radius: radius, startAngle: angle, endAngle: toAngleDeg, clockwise: true)
        piePath.addArcWithCenter(pt34, radius: (radius - innerRadius)/2, startAngle: toAngleDeg, endAngle: toAngleDeg + CGFloat(M_PI), clockwise: true)
        piePath.addArcWithCenter(center, radius: innerRadius, startAngle: DEG2RAD(CGFloat(toAngle)), endAngle: angle, clockwise: false)
        
        piePath.closePath()
        
        return piePath.CGPath
    }
}