//
//  ChannelTabViewController.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-9-26.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

class ChannelTabViewController: UITabBarController {

    var myFmLabelReco:UITapGestureRecognizer?
    var findMusicReco: UITapGestureRecognizer?
    
    var clistdelegate:ChannelProtocol?
    var allChannels: NSArray = NSArray()
    var currC: NSString = ""
    
    var blurMode: Bool = false
    
    var headerBg: UIView?
    var findMusicLabel: UILabel?
    var myFmLabel: UILabel?
    var borderBottom: UIView?
    var indicator: UIView?
    
    func setChannelData(allC: NSArray, currC: NSString) {
        self.allChannels = allC
        self.currC = currC
        
        var channelController = self.viewControllers![0] as ChannelListViewController
        channelController.setChannelData(self.allChannels, currC: self.currC)
    }
    
    func setDelegate(dele:ChannelProtocol?){
        self.clistdelegate = dele
        var channelController = self.viewControllers![0] as ChannelListViewController
        channelController.delegate = self.clistdelegate
    }

    override func viewDidLoad() {
        NSLog("view count\(self.viewControllers?.count)")
        
        self.myFmLabelReco = UITapGestureRecognizer(target: self, action:Selector("onFmLabelTap:"))
        self.findMusicReco = UITapGestureRecognizer(target: self, action:Selector("onFindMusicTap:"))
        
        var channelController = self.viewControllers![0] as ChannelListViewController
        channelController.delegate = self.clistdelegate
        channelController.setChannelData(self.allChannels, currC: self.currC)
        channelController.title = "发现音乐"
        
        self.headerBg = UIView(frame: CGRectMake(0,0,320,65))
        self.headerBg!.backgroundColor = UIColor(red: 235.0/255.0, green: 244.0/255.0, blue: 237.0/255.0, alpha: 1.00)
        self.view.addSubview(self.headerBg!)
        
        self.findMusicLabel = UILabel(frame: CGRectMake(0,24,160,41));
        self.findMusicLabel!.text = "发现音乐"
        self.findMusicLabel!.textAlignment = NSTextAlignment.Center
        self.findMusicLabel!.userInteractionEnabled = true
        self.findMusicLabel!.addGestureRecognizer(self.findMusicReco!)
        self.view.addSubview(self.findMusicLabel!)

        self.myFmLabel = UILabel(frame: CGRectMake(160,24,160,41));
        self.myFmLabel!.text = "我的FM"
        self.myFmLabel!.textAlignment = NSTextAlignment.Center
        self.myFmLabel!.userInteractionEnabled = true
        self.myFmLabel!.addGestureRecognizer(self.myFmLabelReco!)
        self.view.addSubview(self.myFmLabel!)
        
        self.borderBottom = UIView(frame: CGRectMake(0,65,320,0.5));
        self.borderBottom!.backgroundColor = UIColor(red:178/255.0, green: 178.0/255.0, blue: 178.0/255.0, alpha: 1.00)
        self.view.addSubview(self.borderBottom!)
        
        self.indicator = UIView(frame: CGRectMake(15,61,130,4));
        self.indicator!.backgroundColor = UIColor(red:107/255.0, green: 189.0/255.0, blue: 122.0/255.0, alpha: 1.00)
        self.view.addSubview(self.indicator!)
        
        let staticImage:UIImageView = UIImageView(frame: CGRectMake(0,0,320,40))
        staticImage.image = UIImage(named: "like.png")
        //self.view.addSubview(staticImage)
        
        self.tabBar.hidden = true
        self.setBlurMode(self.blurMode)
    }
    
    func setBlurMode(blur: Bool) {
        self.blurMode = blur;
        let blurColor:CGFloat = 212.0 / 255.0
        let nonblurColor: CGFloat = 0.2
        if (self.blurMode) {
            self.indicator!.hidden = true
            self.headerBg!.hidden = true
            self.myFmLabel!.textColor = UIColor(red: blurColor, green: blurColor, blue: blurColor, alpha: 1.0)
            self.findMusicLabel!.textColor = UIColor(red: blurColor, green: blurColor, blue: blurColor, alpha: 1.0)
            self.findMusicLabel!.removeGestureRecognizer(self.findMusicReco!)
            self.myFmLabel!.removeGestureRecognizer(self.myFmLabelReco!)
        } else {
            self.indicator!.hidden = false
            self.headerBg!.hidden = false
            self.myFmLabel!.textColor = UIColor(red: nonblurColor, green: nonblurColor, blue: nonblurColor, alpha: 1.0)
            self.findMusicLabel!.textColor = UIColor(red: nonblurColor, green: nonblurColor, blue: nonblurColor, alpha: 1.0)
            self.findMusicLabel!.addGestureRecognizer(self.findMusicReco!)
            self.myFmLabel!.addGestureRecognizer(self.myFmLabelReco!)
        }
    }
    
    func hideTopButtons(hideme: Bool) {
        if(hideme) {
            self.myFmLabel?.hidden = true
            self.borderBottom?.hidden = true
            self.indicator?.hidden = true
            self.findMusicLabel?.hidden = true
            self.headerBg?.hidden = true
        } else {
            self.myFmLabel?.hidden = false
            self.borderBottom?.hidden = false
            self.indicator?.hidden = false
            self.findMusicLabel?.hidden = false
            self.headerBg?.hidden = false
        }
    }
    
    func changeView(selMode:NSInteger) {
        NSLog("\(self.selectedIndex)->\(selMode)")
        
        if self.selectedIndex == selMode {
            return
        }
        
        UIView.animateWithDuration(0.8, animations:{
            if self.selectedIndex == 0 {
                self.indicator!.frame.origin.x = 175
            } else {
                self.indicator!.frame.origin.x = 15
            }
        })
        
        self.selectedIndex = selMode
    }
    
    func onFmLabelTap(recognizer: UITapGestureRecognizer) {
        NSLog("clickc")
        if recognizer.view == self.myFmLabel! {
            self.changeView(1)
        }
    }
    
    func onFindMusicTap(recognizer: UITapGestureRecognizer) {
        NSLog("clickc")
        if recognizer.view == self.findMusicLabel! {
            self.changeView(0)
        }
    }
}
