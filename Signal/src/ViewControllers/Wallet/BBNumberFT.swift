//
//  BBNumberFT.swift
//  Signal
//
//  Created by 张忠 on 2018/6/22.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class BBNumberFT: NSObject {
    // >= 1k 两位有效小数
    var bigFT = NumberFormatter()
    // 1k ~ 0.01 6位小数
    var middleFT = NumberFormatter()
    // < 0.01 4位有效数字
    var smallFT = NumberFormatter()
    
    var dateFormatter = DateFormatter()
    
    static let shared : BBNumberFT = {
        let instance = BBNumberFT()
        return instance
    }()
    
    override init() {
        super.init()
        bigFT.roundingMode = .halfUp
        bigFT.numberStyle = .decimal
        bigFT.minimumFractionDigits = 0
        bigFT.maximumFractionDigits = 2
        
        middleFT.roundingMode = .halfUp
        middleFT.numberStyle = .decimal
        middleFT.minimumFractionDigits = 1
        middleFT.maximumFractionDigits = 6
        
        smallFT.roundingMode = .halfUp
        smallFT.numberStyle = .decimal
        smallFT.usesSignificantDigits = true
        smallFT.minimumSignificantDigits = 2
        smallFT.maximumSignificantDigits = 4
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    //返回一个合适的显示价格，至少两个有效数字
    func goodPrice(value:Double) -> String{
        return "≈" + goodNumber(value: value) + "CNY"
    }
    
    func goodNumber(value:Double) -> String{
        let num = NSNumber(value: value)
        if value >= 1000 {
            return bigFT.string(from: num) ?? "ERROR"
        }
        else if value >= 0.01 {
            return middleFT.string(from: num) ?? "ERROR"
        }
        else {
            return smallFT.string(from: num) ?? "ERROR"
        }
    }
    
    func goodTimeString(time:Date) -> String {
        return dateFormatter.string(from:time)
    }
}
