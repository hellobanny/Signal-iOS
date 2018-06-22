//
//  BBHistoryType.swift
//  Signal
//
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

enum BBHistoryType {
    case all
    case deposit
    case withdraw
    
    func historyFrom(json:JSON) -> [BBBaseHistory]{
        if self == .all {
            return BBCommonHistory.historyArrayFrom(json: json)
        }
        else if self == .deposit{
            return BBDepositHistory.historyArrayFrom(json:json)
        }
        else {
            return BBWithdrawHistory.historyArrayFrom(json:json)
        }
    }
    
    func name() -> String{
        if self == .all {
            return "历史明细"
        }
        else if self == .deposit{
            return "充值记录"
        }
        else {
            return "提现记录"
        }
    }
}
