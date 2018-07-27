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
        self.textColor = UIColor.bbTextBlack
        self.font = UIFont.systemFont(ofSize: 36)
    }
    
    func toMiddleLabel(){
        self.textColor = UIColor.bbTextBlack
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    func toSmallLabel(){
        self.textColor = UIColor.bbTextLight
        self.font = UIFont.systemFont(ofSize: 12)
    }
}
