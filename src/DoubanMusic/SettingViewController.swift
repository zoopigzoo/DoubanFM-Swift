//
//  SettingViewController.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-10-1.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = false
    }
}