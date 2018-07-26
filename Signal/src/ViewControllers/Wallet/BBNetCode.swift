//
//  BBNetCode.swift
//  Signal
//
//  Created by 张忠 on 2018/7/26.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

enum BBNetCode : Int {
    case success = 200
    case balanceLess = 90001
}
/*
class BBNetCode: NSObject {
    static let  NetCodeSuccess = 200    //成功
    static let  NetCodeBalaceLess = 90001 //余额不足
    static let  NetCodeAddressError = 90002 //目标地址不存在
    static let  NetCodePaywordError = 90003 //密码错误
    static let  NetCodeAccountLocked = 90004 // 账户已锁定, 30分钟自动解锁
    static let  NetCodePaywordUnset = 90005 //交易密码未设置
}*/
