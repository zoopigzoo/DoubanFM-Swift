//
//  ChannleListViewController.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-9-21.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

protocol ChannelProtocol{
    func onChangeChannel(channel_id:NSString)
}


class ChannelListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var isInChannel:Bool = true
    @IBOutlet var taprecog: UITapGestureRecognizer!
    
    //for program
    @IBOutlet weak var programlabel: UILabel!
    
    //for channels
    @IBOutlet weak var channellabel: UILabel!
    @IBOutlet weak var channelTable: UITableView!
    
    var currentChannel:NSString = ""
    
    var delegate:ChannelProtocol?
    var sectionData: Array<String> = ["我的兆赫", "推荐兆赫", "热门兆赫", "上升最快兆赫", "品牌兆赫"]
    var channelSectionData: Array<NSArray> = []
    var channelName2CateDict: [String: NSInteger] = ["新歌":3,"华语":3,"新嘉年华夜冲":4, "世界等我出发": 4, "民谣":3, "轻音乐":3, "爵士":3, "说唱":3, "日语":3, "韩语":3, "圣诞":3, "工作学习": 1, "户外":1, "休息":1,"亢奋":1,"舒缓":1, "七零":1, "粤语":1, "摇滚":1, "原声":1, "咖啡馆":1, "豆瓣好歌曲":1, "雷鬼":1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ChannelTableCell", bundle: nil)
        self.channelTable.registerNib(nib, forCellReuseIdentifier: "ChannelTableCell")
        
        self.setMode(true)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        for cell in self.channelTable.visibleCells() {
            if (cell as ChannelTableCell).playimage.hidden == false {
                (cell as ChannelTableCell).playimage.addAnimation()
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMode(isC: Bool) {
        self.isInChannel = isC
        let mainColor:UIColor = UIColor(red: 0.82, green: 0.92, blue: 0.83, alpha: 1.00)
        if(self.isInChannel) {
            self.channellabel.textColor = mainColor
            self.programlabel.textColor = UIColor.blackColor()
            self.channelTable.hidden = false
            
            self.programlabel.addGestureRecognizer(self.taprecog)
            self.channellabel.removeGestureRecognizer(self.taprecog)
        } else {
            self.channellabel.textColor = UIColor.blackColor()
            self.programlabel.textColor = mainColor
            self.channelTable.hidden = true
            
            self.programlabel.removeGestureRecognizer(self.taprecog)
            self.channellabel.addGestureRecognizer(self.taprecog)
        }
    }
    
    func setChannelData(allChannels: NSArray, currC: NSString) {
        if(sectionData.count == 0
            || allChannels.count == 0) {
            return
        }
        
        self.channelSectionData = Array<NSArray>();
        self.currentChannel = currC;
        for index in 0...sectionData.count - 1 {
            self.channelSectionData.append(NSArray())
        }
    
        for index in 0...allChannels.count - 1 {
            var data = allChannels[index] as NSDictionary
            var name = data["name"] as String
            var id = data["channel_id"] as String
            if let channelindex = self.channelName2CateDict[name] {
                self.channelSectionData[channelindex] = self.channelSectionData[channelindex].arrayByAddingObject(data)
            } else if name.hasSuffix("系") {
                self.channelSectionData[1] = self.channelSectionData[1].arrayByAddingObject(data)
            } else if countElements(name) > 5 {
                self.channelSectionData[4] = self.channelSectionData[4].arrayByAddingObject(data)
            } else {
                self.channelSectionData[2] = self.channelSectionData[2].arrayByAddingObject(data)
            }
        }
        
        self.channelSectionData[0] = self.channelSectionData[0].arrayByAddingObject(self.selfDefChannelData("-50",name:"我的私人"))
        self.channelSectionData[0] = self.channelSectionData[0].arrayByAddingObject(self.selfDefChannelData("-100",name:"我的红心"))
        
        self.channelTable!.reloadData()
        
        var selsindex = -1
        var selrindex = -1
        for (sindex,cdata) in enumerate(self.channelSectionData) {
            for (dindex, celldata) in enumerate(cdata) {
                if((celldata["channel_id"] as String) == currC) {
                    selsindex = sindex
                    selrindex = dindex
                    break
                }
            }
            
            if(selsindex >= 0) {
                break
            }
        }
        
        self.channelTable!.selectRowAtIndexPath(NSIndexPath(forRow: selrindex, inSection: selsindex), animated: false, scrollPosition: UITableViewScrollPosition.Top)
    }
    
    func selfDefChannelData(id: String, name: String) -> NSDictionary{
        var dict:NSMutableDictionary = NSMutableDictionary()
        dict["channel_id"] = id
        dict["name"] = name
        return dict
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionData[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(channelSectionData.count == 0) {
            return 0;
        }
        
        return channelSectionData[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let simpleTableIdentifier = "ChannelTableCell"
        
        var cell=tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as ChannelTableCell?
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        let rowData:NSDictionary=self.channelSectionData[indexPath.section][indexPath.row] as NSDictionary
        
        if(self.currentChannel == rowData["channel_id"] as String) {
            cell!.playimage.hidden = false
        } else {
            cell!.playimage.hidden = true
            cell!.playimage.addAnimation()
        }
        
        cell!.setChannelName(rowData["name"] as String)
        return cell!
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        var rowData:NSDictionary=self.channelSectionData[indexPath.section][indexPath.row] as NSDictionary
        let channel_id = rowData["channel_id"] as NSString
        
        for cell in tableView.visibleCells() {
            (cell as ChannelTableCell).playimage.hidden = true
        }
        let currCell = tableView.cellForRowAtIndexPath(indexPath) as ChannelTableCell
        currCell.playimage.hidden = false
        currCell.playimage.addAnimation()
        
        delegate?.onChangeChannel(channel_id)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTap(recognizer: UITapGestureRecognizer) {
        NSLog("called tap")
        if recognizer.view == self.programlabel {
            self.setMode(false)
        } else {
            self.setMode(true)
        }
    }
}