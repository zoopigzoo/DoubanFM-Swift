//
//  MyFMViewController.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-9-28.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

class MyFMViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var myfmTable: UITableView!
    
    var settingController: IASKAppSettingsViewController?
    var myoffineController: SettingViewController?
    var musicphoneController: SettingViewController?
    var myfavController: SettingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MyFMTableCell", bundle: nil)
        self.myfmTable.registerNib(nib, forCellReuseIdentifier: "MyFMTableCell")
        
        if(self.settingController == nil) {
            self.settingController = IASKAppSettingsViewController()
            self.settingController?.delegate = self
            self.settingController?.title = "设置"
            self.settingController?.showDoneButton = false
            self.settingController?.navigationItem.rightBarButtonItem = nil
        }
 
        if(self.myoffineController == nil) {
            self.myoffineController = self.storyboard!.instantiateViewControllerWithIdentifier("SettingViewController") as SettingViewController
            self.myoffineController?.title = "离线单曲"
        }
        
        if(self.musicphoneController == nil) {
            self.musicphoneController = self.storyboard!.instantiateViewControllerWithIdentifier("SettingViewController") as SettingViewController
            self.musicphoneController?.title = "手机里的歌曲"
        }
        
        if(self.myfavController == nil) {
            self.myfavController = self.storyboard!.instantiateViewControllerWithIdentifier("SettingViewController") as SettingViewController
            self.myfavController?.title = "我的收藏"
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let tabController: ChannelTabViewController! = self.tabBarController! as  ChannelTabViewController;
        tabController.hideTopButtons(false)

        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let simpleTableIdentifier = "MyFMTableCell"
        
        var cell=tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as MyFMTableCell?
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        if(indexPath.row == 0) {
            NSLog("\row(indexPath.row)")
            cell!.setCellContent("我的离线", labelImage: "download.png")
        } else if(indexPath.row == 1) {
            NSLog("\row(indexPath.row)")
            cell!.setCellContent("手机里的歌曲", labelImage: "mobile.png")
        } else if(indexPath.row == 2) {
            NSLog("\row(indexPath.row)")
            cell!.setCellContent("我的收藏", labelImage: "star.png")
        } else if(indexPath.row == 3) {
            NSLog("\row(indexPath.row)")
            cell!.setCellContent("设置", labelImage: "setting.png")
        } else {
            cell!.setCellContent("", labelImage: "")
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        let tabController: ChannelTabViewController! = self.tabBarController! as  ChannelTabViewController;
        
        let newBackButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = newBackButton
        
//        let rootController = UIApplication.sharedApplication().delegate?.window!?.rootViewController as? UINavigationController
        let rootController = self.navigationController
        
        if(indexPath.row == 0) {
            tabController.hideTopButtons(true)
            rootController!.pushViewController(self.myoffineController!, animated: true)
        } else if(indexPath.row == 1) {
            tabController.hideTopButtons(true)
            rootController!.pushViewController(self.musicphoneController!, animated: true)
        } else if(indexPath.row == 2) {
            tabController.hideTopButtons(true)
            rootController!.pushViewController(self.myfavController!, animated: true)
        } else if(indexPath.row == 3) {
            tabController.hideTopButtons(true)
            rootController!.pushViewController(self.settingController!, animated: true)
            self.settingController?.navigationController?.navigationBarHidden = false            
        } else {
            NSLog("Click Row:\(indexPath.row)")
        }
    }
}