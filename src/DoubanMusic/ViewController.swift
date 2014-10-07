//
//  ViewController.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-9-17.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import UIKit
import MediaPlayer
import QuartzCore


class ViewController: UIViewController, ChannelProtocol {
    @IBOutlet weak var songimage: UIImageView!
    @IBOutlet weak var channelname: UILabel!
    @IBOutlet weak var singername: UILabel!
    @IBOutlet weak var songname: UILabel!
    @IBOutlet weak var backroundprogress: RoundProgressUIView!
    @IBOutlet weak var playBtn: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var channelData:NSArray=NSArray()
    var currChannel:NSDictionary = NSDictionary()
    
    var songData:NSArray = NSArray()
    var currsongIndex:NSInteger = 0
    
    var audioPlayer:MPMoviePlayerController=MPMoviePlayerController();
    var timer:NSTimer?
    
    var innerRadius: CGFloat = 70
    var progressRadius: CGFloat = 80
    var stopAlpha: CGFloat = 0.2
    var resumeAlpha: CGFloat = 1.0
    
    var minmode:Bool = false
    
    @IBOutlet var songImageTap: UITapGestureRecognizer!
    
    @IBAction func stoptag(recognizer: UITapGestureRecognizer){
        NSLog("called")
        if recognizer.view==self.playBtn {
            playBtn.hidden = true
            audioPlayer.play()
            playBtn.removeGestureRecognizer(songImageTap)
            self.songimage.addGestureRecognizer(songImageTap)
            
            if(!self.minmode) {
                self.channelname.alpha = resumeAlpha
                self.songname.alpha = resumeAlpha
                self.singername.alpha = resumeAlpha
            } else {
                self.channelname.alpha = 0.0
                self.songname.alpha = 0.0
                self.singername.alpha = 0.0
            }
            
            self.songimage.alpha = resumeAlpha
        }else if recognizer.view==self.songimage {
            playBtn.hidden=false
            audioPlayer.pause()
            playBtn.addGestureRecognizer(songImageTap)
            self.songimage.removeGestureRecognizer(songImageTap)

            if(!self.minmode) {
                self.channelname.alpha = stopAlpha
                self.songname.alpha = stopAlpha
                self.singername.alpha = stopAlpha
            } else {
                self.channelname.alpha = 0.0
                self.songname.alpha = 0.0
                self.singername.alpha = 0.0
            }
            
            self.songimage.alpha = stopAlpha
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playBtn.hidden = true
        
//        self.backroundprogress.setProgressWidthRatio(10 / 80)
        //self.songimage.hidden = true
        self.currsongIndex = 0;
        self.updateProgress(0, animated: false)
        self.songimage.addGestureRecognizer(songImageTap)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var channelC:ChannelTabViewController=segue.destinationViewController as ChannelTabViewController
        
        channelC.clistdelegate = self
        channelC.currC = self.currChannel["channel_id"] as NSString
        channelC.allChannels = self.channelData
    }
    
    func movieFinishedCallback(notify:NSNotification){
        NSLog("finished")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func likeButtonClick(sender: AnyObject) {
    }
    
    @IBAction func delButtonClick(sender: AnyObject) {
        self.currsongIndex += 1
        self.setPlayingSongInfo(self.songData[self.currsongIndex] as NSDictionary)
    }
    
    @IBAction func nextsongButtongClick(sender: AnyObject) {
        self.currsongIndex += 1
        self.setPlayingSongInfo(self.songData[self.currsongIndex] as NSDictionary)
    }
    
    func updateProgress(progress: Float, animated: Bool){
        self.backroundprogress.setProgress(progress)
    }
    
    func onChangeChannel(channel_id: NSString) {
        self.changeChannel(channel_id)
    }
    
    func updateChannleList(jsonResult: NSDictionary){
        var tmpchannleData = jsonResult["channels"] as NSArray!
        self.channelData = NSArray()
        for index in 0...tmpchannleData.count-1 {
            var tmpchan = tmpchannleData[index] as NSDictionary
            var tmpid: AnyObject? = tmpchan["channel_id"]
            var uuidString: String? = tmpchan["channel_id"] as AnyObject? as? String
            if(uuidString != nil) {
                self.channelData = self.channelData.arrayByAddingObject(tmpchan)
            }
        }
        
        if(channelData.count > 0) {
            self.changeChannel("FIRST DEFAULT")
        }
    }
    
    func changeChannel(channelid: NSString){
        var channelIndex:NSInteger = -1;
        var firstNonNilChannel: NSInteger = -1;
        for index in 0...channelData.count-1 {
            var tmpchan = channelData[index] as NSDictionary
            var tmpid: AnyObject? = tmpchan["channel_id"]
            var uuidString: String? = tmpchan["channel_id"] as AnyObject? as? String
            if(uuidString != nil && firstNonNilChannel == -1) {
                firstNonNilChannel = index
            }
            if(uuidString != nil && uuidString == channelid) {
                channelIndex = index
                break
            }
        }
        
        if(channelIndex == -1) {
            channelIndex = firstNonNilChannel
        }
        
        currChannel = channelData[channelIndex] as NSDictionary
        var displayText: NSString = currChannel["name"] as NSString
        displayText = "• ● " + displayText + " MHz" + " ● •"
        let displayLength = displayText.length
        let attributeString:NSMutableAttributedString = NSMutableAttributedString(string: displayText)
        let mainColor:UIColor = UIColor(red: 0.82, green: 0.92, blue: 0.83, alpha: 1.00)
        let mainColorRange = NSMakeRange(0, 1)
        attributeString.addAttribute(NSForegroundColorAttributeName, value: mainColor, range:mainColorRange)
        let lastColorRange = NSMakeRange(displayLength-1, 1)
        attributeString.addAttribute(NSForegroundColorAttributeName, value: mainColor, range:lastColorRange)
        channelname.attributedText = attributeString
        
        let getchannelid = currChannel["channel_id"] as NSString
        self.fetchSongList(getchannelid)
    }
    
    func updateSongList(jsonResult: NSDictionary) {
        songData = jsonResult["song"] as NSArray
        currsongIndex = 0;
        self.setPlayingSongInfo(songData[currsongIndex] as NSDictionary)
    }
    
    func setPlayingSongInfo(songInfo: NSDictionary) {
        self.updateProgress(0, animated: true)
        
        songname.text = songInfo["title"] as NSString
        singername.text = songInfo["artist"] as NSString
        
        let url = songInfo["picture"] as NSString
        let imgURL:NSURL=NSURL(string:url)
        let request:NSURLRequest=NSURLRequest(URL:imgURL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
            let img=UIImage(data:data)
            self.songimage.image = img
        })

        audioPlayer.stop()
        let songurl = songInfo["url"] as String
        audioPlayer.contentURL = NSURL(string: songurl)
        audioPlayer.play()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        
    }
    
    func onUpdate(){
        let c=audioPlayer.currentPlaybackTime
        if c>0.0 {
            let t=audioPlayer.duration
            
            if c >= t{
                self.currsongIndex += 1
                self.setPlayingSongInfo(self.songData[self.currsongIndex] as NSDictionary)
            } else {
                let p:CFloat=CFloat(c/t)
                self.updateProgress(p, animated: true)
                
                let all:Int=Int(c)
                let m:Int=all % 60
                let f:Int=Int(all/60)
                var time:String=""
                if f<10{
                    time="0\(f):"
                }else {
                    time="\(f)"
                }
                if m<10{
                    time+="0\(m)"
                }else {
                    time+="\(m)"
                }
            }
        }
    }

    func fetchSongList(channelID: NSString){
        let manager = AFHTTPRequestOperationManager()
        let url = "http://douban.fm/j/mine/playlist?channel=\(channelID)"
        let params = []
        
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
                
                self.updateSongList(responseObject as NSDictionary!)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
}

