//
//  BBTimeFT.swift
//  Signal
//
//  Created by 张忠 on 2018/7/13.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftDate

class BBTimeFT: NSObject {
    var dateFormatter = DateFormatter()
    var dfDate = DateFormatter()
    var dfTime = DateFormatter()
    
    static let shared : BBTimeFT = {
        let instance = BBTimeFT()
        return instance
    }()
    
    override init() {
        super.init()

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        dfDate.dateStyle = .short
        dfDate.timeStyle = .none
        dfTime.dateStyle = .none
        dfTime.timeStyle = .short
    }
    
    func goodTimeString(time:Date) -> String {
        return dateFormatter.string(from:time)
    }
    
    //如果是今天，返回时间，否则返回日期
    func shortTimeString(time:Date) -> String{
        if time.isToday {
            return dfTime.string(from:time)
        }
        else {
            return dfDate.string(from:time)
        }
    }
        
}
