//
//  RoundUIImageView.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-10-3.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

class RoundUIImageView: UIImageView {
    var borderWidth: CGFloat = 0.0
    var borderColor: UIColor = UIColor.whiteColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override init(image: UIImage!) {
        super.init(image: image)
        self.setup()
    }
    
    override init() {
        super.init()
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addMaskToBounds(self.frame)
    }
    
    func setBorderWidth(w: CGFloat) {
        self.borderWidth = w
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setBorderColor(c: UIColor) {
        self.borderColor = c
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setup() {
        self.contentMode = UIViewContentMode.ScaleAspectFill;
        self.clipsToBounds = true;
        
        self.borderWidth = 0.0;
        self.borderColor = UIColor.whiteColor();
    }
    
    func addMaskToBounds(maskBounds: CGRect){
        var maskLayer:CAShapeLayer = CAShapeLayer()
        var maskPath:CGPathRef = CGPathCreateWithEllipseInRect(maskBounds, nil)
        maskLayer.bounds = maskBounds
        maskLayer.path = maskPath
        maskLayer.fillColor = UIColor.blackColor().CGColor
        
        var point:CGPoint = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2)
        maskLayer.position = point
        
        self.layer.mask = maskLayer
        if(self.borderWidth > 0) {
            var shape:CAShapeLayer = CAShapeLayer()
            shape.bounds = maskBounds
            shape.path = maskPath
            shape.lineWidth = self.borderWidth * 2.0
            shape.strokeColor = self.borderColor.CGColor
            shape.fillColor = UIColor.clearColor().CGColor
            shape.position = point
            
            self.layer.addSublayer(shape)
        }
        
        //maskpath.release
    }
}