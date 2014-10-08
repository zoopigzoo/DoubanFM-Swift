//
//  ChannelTableCell.swift
//  DoubanMusic
//
//  Created by zoopigzoo on 14-9-21.
//  Copyright (c) 2014年 zoopigzoo. All rights reserved.
//

import Foundation

class ChannelTableCell: UITableViewCell {

    @IBOutlet weak var channelname: UILabel!
    
    var playimage: PlayUIView! = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.playimage = PlayUIView(frame: CGRectMake(280, 45, 25, 20))
        self.contentView.addSubview(self.playimage)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setChannelName(name: NSString) {
        
        var displayText: NSString = name
        displayText = displayText + " MHz"
        let displayLength = displayText.length
        
        let attributeString:NSMutableAttributedString = NSMutableAttributedString(string: displayText)
        
        let beforefont: UIFont = UIFont(name: "Helvetica-Light", size: 19)!
        let beforeColorRange = NSMakeRange(0, displayLength-3)
        attributeString.addAttribute(NSFontAttributeName, value: beforefont, range:beforeColorRange)
        
        let font: UIFont = UIFont(name: "Helvetica-Light", size: 15)!
        let lastColorRange = NSMakeRange(displayLength-3, 3)
        attributeString.addAttribute(NSFontAttributeName, value: font, range:lastColorRange)
        
        self.channelname.attributedText = attributeString
    }
}