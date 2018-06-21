//
//  BBCommon.swift
//  Signal
//
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class BBCommon: NSObject {
    static let PageSize:Int = 10
    
    
    static let  NetCodeSuccess = 200    //成功
    static let  NetCodeBalaceLess = 120001 //余额不足
    static let  NetCodeAddressError = 120002 //目标地址不存在
    static let  NetCodePaywordError = 120003 //密码错误
    static let  NetCodeAccountLocked = 120004 // 账户已锁定, 30分钟自动解锁
    static let  NetCodePaywordUnset = 120005 //交易密码未设置

}
