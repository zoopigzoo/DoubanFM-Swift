//
//  FrontViewController.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-10-1.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

class FrontViewController: UIViewController {
    var playController: ViewController?
    var tabController: ChannelTabViewController?
    var topTabReco:UITapGestureRecognizer?
    var bottomTabReco: UITapGestureRecognizer?
    var playingPanRec: UIPanGestureRecognizer?
    
    let btn_start:CGFloat = 155
    let btn_stride:CGFloat = 58
    let btn_ytop:CGFloat = 10
    let btn_size:CGFloat = 30
    
    let org_start:CGFloat = 41
    let org_stride:CGFloat = 94
    let org_ytop:CGFloat = 411
    let org_size:CGFloat = 50
    
    //calc = desty + 0.5*srcsize - 0.5*destsize
    let bg:CGRect = CGRectMake(-40,-45,34.28,34.28)
    var bgorg:CGRect?
    
    let songimage:CGRect = CGRectMake(-30, -35, 30, 30)
    var songimageorg: CGRect?
    
    let playbtn: CGRect = CGRectMake(-40,-45,34.28,34.28)
    var playbtnorg: CGRect?
    
    let maxPlayControlMove: CGFloat = 446
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.topTabReco = UITapGestureRecognizer(target: self, action:Selector("onTopTabTapped:"))
        self.bottomTabReco = UITapGestureRecognizer(target: self, action:Selector("onBottomTabTapped:"))
        self.playingPanRec = UIPanGestureRecognizer(target: self, action: Selector("onBottomPan:"))
        
        self.tabController = storyboard.instantiateViewControllerWithIdentifier("ChannelTabViewController") as? ChannelTabViewController
        self.tabController!.blurMode = true
        self.addChildViewController(self.tabController!)
        self.tabController!.view.frame = CGRectMake(0, 0, 320, 568);
        self.tabController!.view.addGestureRecognizer(self.topTabReco!)
        self.view.addSubview(self.tabController!.view)
        self.tabController!.didMoveToParentViewController(self)
        self.playController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        self.playController!.view.addGestureRecognizer(self.playingPanRec!)
        self.addChildViewController(self.playController!)
        self.playController!.view.frame = CGRectMake(0, 59, 320, 568)
        self.view.addSubview(self.playController!.view)
        self.playController!.didMoveToParentViewController(self)
        
        self.fetchChannelList()
        
        self.bgorg = self.playController!.backroundprogress.frame
        self.songimageorg = self.playController!.songimage.frame
        self.playbtnorg = self.playController!.playBtn.frame
        NSLog("org y \(self.bgorg!.origin.y)")
    }
    
    let duration: CFTimeInterval = 1.0
    
    func move(fromPoint: CGPoint, toPoint: CGPoint) -> CABasicAnimation {
        var xAni: CABasicAnimation = CABasicAnimation(keyPath: "position")
        xAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        xAni.fromValue = NSValue(CGPoint: fromPoint)
        xAni.toValue = NSValue(CGPoint: toPoint)
//        xAni.fillMode = kCAFillModeForwards
//        xAni.removedOnCompletion = false;
        xAni.duration = self.duration
        
        return xAni;
    }
    
    func moveX(x: CGFloat) -> CABasicAnimation {
        var xAni: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation")
        xAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        xAni.fromValue = 0.0
        xAni.toValue = x
//        xAni.fillMode = kCAFillModeForwards;
//        xAni.removedOnCompletion = false;
        xAni.beginTime = 0.0
        xAni.duration = self.duration
        
        return xAni;
    }

    func moveY(y: CGFloat) -> CABasicAnimation {
        var xAni: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        xAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        xAni.fromValue = 0.0
        xAni.toValue = y
//        xAni.fillMode = kCAFillModeForwards;
//        xAni.removedOnCompletion = false;
        xAni.duration = self.duration
        
        return xAni;
    }
    
    func scale(from: CGFloat, s: CGFloat) -> CABasicAnimation {
        var xAni: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        xAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        xAni.fromValue = from
        xAni.toValue = s
//        xAni.fillMode = kCAFillModeForwards;
//        xAni.removedOnCompletion = false;
        xAni.duration = self.duration
        
        return xAni;
    }
    
    func cradius(orgr: CGFloat, r: CGFloat) -> CABasicAnimation {
        var radiusAnimation: CABasicAnimation = CABasicAnimation(keyPath: "cornerRadius")
        radiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        radiusAnimation.fromValue = orgr
        radiusAnimation.toValue = r
        radiusAnimation.duration = self.duration

        return radiusAnimation
    }
    
    func CGRectCenter(rect: CGRect) -> CGPoint
    {
        return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
//        if(anim.valueForKey("songimagechangesize").isEqual("tosmall")) {
//            NSLog("end small\(self.playController!.songimage.frame.origin.x)")
//            NSLog("end small\(self.playController!.songimage.frame.size.width)")
//            NSLog("\(self.playController!.songimage.transform.a)")
//            self.playController!.songimage.frame = CGRectMake(27.0, 20.0, 30.0, 30.0)
//        } else if(anim.valueForKey("songimagechangesize").isEqual("tobig")){
//            NSLog("end big")
//            self.playController!.songimage.frame = CGRectMake(90, 85, 140, 140)
//        } else if(anim.valueForKey("songimagechangesize").isEqual("protosmall")){
//            NSLog("end pro small")
//            self.playController!.backroundprogress.frame = CGRectMake(24.86, 17.86, 34.28, 34.28)
//        } else if(anim.valueForKey("songimagechangesize").isEqual("protobig")){
//            NSLog("end pro big")
//            self.playController!.backroundprogress.frame = CGRectMake(80, 75, 160, 160)
//        } else if(anim.valueForKey("songimagechangesize").isEqual("playbtnsmall")){
//            NSLog("end playbtn small")
//            self.playController!.playBtn.frame = CGRectMake(24.86, 17.86, 34.28, 34.28)
//        } else if(anim.valueForKey("songimagechangesize").isEqual("playbtnbig")){
//            NSLog("end playbtn big")
//            self.playController!.playBtn.frame = CGRectMake(80, 75, 160, 160)
//        }
    }
    
    func onTopTabTapped(recognizer: UITapGestureRecognizer) {
        self.animatedtomin()
    }
    
    func onBottomTabTapped(recognizer: UITapGestureRecognizer) {
        self.animatedtomax()
    }
    
    func onBottomPan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.playController!.view)
        
        if (recognizer.state == UIGestureRecognizerState.Ended)
        {
            if(translation.y > 200) {
                self.animatedtomin()
            } else if(translation.y <= 200) {
                self.animatedtomax()
            }
            return;
        }
        
        if(translation.y < 0) {
            return
        }
        
        if(translation.y > 0) {
            self.playControlScale(translation.y)
        }
    }
    
    func animatedtomax() {
        UIView.animateWithDuration(self.duration, animations: {
                self.playController!.channelname.alpha = 1.0
                self.playController!.singername.alpha = 1.0;
                self.playController!.songname.alpha = 1.0;
            
                self.playController!.songimage.transform = self.nomoveTransform()
                self.playController!.backroundprogress.transform = self.nomoveTransform()
                self.playController!.playBtn.transform = self.nomoveTransform()
                self.playController!.delBtn.transform = self.nomoveTransform()
                self.playController!.nextBtn.transform = self.nomoveTransform()
                self.playController!.likeBtn.transform = self.nomoveTransform()
                self.playController!.view.transform.ty = 0.0
            }, completion: {
                (value: Bool) in
                self.tabController!.setBlurMode(true);
                self.tabController!.view.addGestureRecognizer(self.topTabReco!)
                self.playController!.view.removeGestureRecognizer(self.bottomTabReco!)
                self.playController!.view.addGestureRecognizer(self.playingPanRec!)
                self.playController!.minmode = false
                
                NSLog("end frame y\(self.playController!.view.frame.origin.y)")
        });
    }
    
    func animatedtomin() {
        UIView.animateWithDuration(self.duration, animations: {
                self.playController!.channelname.alpha = 0.0
                self.playController!.singername.alpha = 0.0;
                self.playController!.songname.alpha = 0.0;
            
                self.playController!.playBtn.transform = self.fromtoTransform(self.playbtnorg!.origin.x, destx: self.playbtn.origin.x, orgy: self.playbtnorg!.origin.y, desty: self.playbtn.origin.y, toscale: self.playbtn.size.width/self.playbtnorg!.size.width, currPercent: 1.0)
            
                self.playController!.songimage.transform = self.fromtoTransform(self.songimageorg!.origin.x, destx: self.songimage.origin.x, orgy: self.songimageorg!.origin.y, desty: self.songimage.origin.y, toscale: self.songimage.size.width/self.songimageorg!.size.width, currPercent: 1.0)
            
                let tmp = self.fromtoTransform(self.bgorg!.origin.x, destx: self.bg.origin.x, orgy: self.bgorg!.origin.y, desty: self.bg.origin.y, toscale: self.bg.size.width/self.bgorg!.size.width, currPercent: 1.0)
                NSLog("dest \(self.playController!.backroundprogress.frame.origin.y) -> ts \(tmp.ty) \(tmp.a)")
                self.playController!.backroundprogress.transform = self.fromtoTransform(self.bgorg!.origin.x, destx: self.bg.origin.x, orgy: self.bgorg!.origin.y, desty: self.bg.origin.y, toscale: self.bg.size.width/self.bgorg!.size.width, currPercent: 1.0)
            
                self.playController!.likeBtn.transform = self.fromtoTransform(self.org_start, destx: self.btn_start, orgy: self.org_ytop, desty: self.btn_ytop, toscale: self.btn_size/self.org_size, currPercent: 1.0)
                self.playController!.delBtn.transform = self.fromtoTransform(self.org_start + self.org_stride, destx: self.btn_start + self.btn_stride, orgy: self.org_ytop, desty: self.btn_ytop, toscale: self.btn_size/self.org_size, currPercent: 1.0)
                self.playController!.nextBtn.transform = self.fromtoTransform(self.org_start + 2 * self.org_stride, destx: self.btn_start + 2 * self.btn_stride, orgy: self.org_ytop, desty: self.btn_ytop, toscale: self.btn_size/self.org_size, currPercent: 1.0)
            
                self.playController!.view.transform.ty = self.maxPlayControlMove
            }, completion: {
                (value: Bool) in
                NSLog("at the end \(self.playController!.backroundprogress.transform.ty)")
                NSLog("at the end \(self.playController!.backroundprogress.frame.origin.y)")
                self.minized()
        });
    }
    
    func minized() {
        self.tabController!.setBlurMode(false);
        self.tabController!.view.removeGestureRecognizer(self.topTabReco!)
        self.playController!.minmode = true
        self.playController!.view.removeGestureRecognizer(self.playingPanRec!)
        self.playController!.view.addGestureRecognizer(self.bottomTabReco!)
    }
    
    func playControlScale(y: CGFloat){
        var ymove: CGFloat = y
        if(ymove > 446) {
            ymove = 446
        }
        
        NSLog("enter scale y\(self.playController!.view.frame.origin.y)")
        
        //move parent view down
        var theTransform = self.playController!.view.transform;
        NSLog("transfrom: \(theTransform.ty), \(theTransform.a)")
        theTransform.ty = ymove;
        self.playController!.view.transform = theTransform;
        
        var currentHeight = self.playController!.view.frame.origin.y;
        NSLog("current y:\(currentHeight), dy:\(y), ymove:\(ymove)")
        var moveDownHeight = currentHeight - 59.0;
        if(moveDownHeight >= 446) {
            moveDownHeight = 446
            self.minized()
        }
        
        //text alpha
        let disappearY: CGFloat = 100
        var nowAlpha: CGFloat = 0.0
        if(moveDownHeight < disappearY) {
            nowAlpha = 1.0 - moveDownHeight / disappearY
        }
        
        self.playController!.channelname.alpha = nowAlpha
        self.playController!.singername.alpha = nowAlpha
        self.playController!.songname.alpha = nowAlpha
     
        var totalPercent: CGFloat = moveDownHeight / 446

        self.playController!.songimage.transform = self.fromtoTransform(self.songimageorg!.origin.x, destx: self.songimage.origin.x, orgy: self.songimageorg!.origin.y, desty: self.songimage.origin.y, toscale: self.songimage.size.width/self.songimageorg!.size.width, currPercent: totalPercent)
        
        self.playController!.playBtn.transform = self.fromtoTransform(self.playbtnorg!.origin.x, destx: self.playbtn.origin.x, orgy: self.playbtnorg!.origin.y, desty: self.playbtn.origin.y, toscale: self.playbtn.size.width/self.playbtnorg!.size.width, currPercent: totalPercent)
        
        self.playController!.backroundprogress.transform = self.fromtoTransform(self.bgorg!.origin.x, destx: self.bg.origin.x, orgy: self.bgorg!.origin.y, desty: self.bg.origin.y, toscale: self.bg.size.width/self.bgorg!.size.width, currPercent: totalPercent)

        self.playController!.likeBtn.transform = self.fromtoTransform(self.org_start, destx: self.btn_start, orgy: self.org_ytop, desty: self.btn_ytop, toscale: self.btn_size/self.org_size, currPercent: totalPercent)
        self.playController!.delBtn.transform = self.fromtoTransform(self.org_start + self.org_stride, destx: self.btn_start + self.btn_stride, orgy: self.org_ytop, desty: self.btn_ytop, toscale: self.btn_size/self.org_size, currPercent: totalPercent)
        self.playController!.nextBtn.transform = self.fromtoTransform(self.org_start + 2 * self.org_stride, destx: self.btn_start + 2 * self.btn_stride, orgy: self.org_ytop, desty: self.btn_ytop, toscale: self.btn_size/self.org_size, currPercent: totalPercent)
    }
    
    func fromtoTransform(orgx: CGFloat, destx: CGFloat, orgy: CGFloat, desty: CGFloat, toscale:CGFloat, currPercent: CGFloat) -> CGAffineTransform{
        var imagedx = (destx - orgx) * currPercent
        var imagedy = (desty - orgy) * currPercent
        var imagesc = 1 - (1 - toscale) * currPercent
        
        return self.scalemoveTransform(imagedx, dy: imagedy, sc: imagesc)
    }
    
    func nomoveTransform() -> CGAffineTransform {
        let tf: CGAffineTransform = CGAffineTransform(a: 1.0, b: 0, c: 0, d: 1.0, tx: 0.0, ty: 0.0)
        return tf
    }
    
    func scalemoveTransform(dx: CGFloat, dy: CGFloat, sc: CGFloat) -> CGAffineTransform {
        let tf: CGAffineTransform = CGAffineTransform(a: sc, b: 0, c: 0, d: sc, tx: dx, ty: dy)
        return tf
    }
    
    func fetchChannelList() {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://www.douban.com/j/app/radio/channels"
        let params = []
        
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
                self.playController!.updateChannleList(responseObject as NSDictionary!)
                
                var channelC:ChannelTabViewController = self.tabController!
                channelC.setDelegate(self.playController!)
                channelC.setChannelData(self.playController!.channelData, currC:self.playController!.currChannel["channel_id"] as NSString)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
}