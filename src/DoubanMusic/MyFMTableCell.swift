//
//  MyFMTableCell.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-9-28.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

class MyFMTableCell: UITableViewCell {
    
    @IBOutlet weak var indicatorImage: UIImageView!
    @IBOutlet weak var indicatorText: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setCellContent(labelText: NSString, labelImage: NSString) {
        self.indicatorText.text = labelText;
        let img=UIImage(named: labelImage)
        self.indicatorImage.image = img
    }
}