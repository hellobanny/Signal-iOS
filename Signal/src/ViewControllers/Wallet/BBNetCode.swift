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
    case balanceLake = 90001
    case addressError = 90002
    case paywordError = 90003
    case accountLocked = 90004
    case paywordUnset = 90005
    case undefine = 7777
    
    func description() -> String {
        switch self {
        case .success:
            return "成功"
        case .balanceLake:
            return "余额不足"
        case .addressError:
            return "钱包地址错误"
        case .paywordError:
            return "支付密码错误"
        case .accountLocked:
            return "账号已经被锁定，30分钟后解锁"
        case .paywordUnset:
            return "支付密码未设置"
        default:
            return "未定义错误"
        }
    }
}
