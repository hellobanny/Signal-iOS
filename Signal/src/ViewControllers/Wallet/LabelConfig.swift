//
//  LabelConfig.swift
//  Signal
//
//  Created by 张忠 on 2018/6/29.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

extension UILabel{
    
    func toLargeLabel(){
        self.textColor = BBCommon.ColorBlackText
        self.font = UIFont.systemFont(ofSize: 36)
    }
    
    func toMiddleLabel(){
        self.textColor = BBCommon.ColorBlackText
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    func toSmallLabel(){
        self.textColor = BBCommon.ColorLightText
        self.font = UIFont.systemFont(ofSize: 12)
    }
}
