//
//  BBWithdrawHistory.swift
//  Signal
//
//  Created by 张忠 on 2018/6/19.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class BBWithdrawHistory : BBBaseHistory {
    var address:String //toAddressAlias
    var txid:String //txid
    var amt:Double //withdrawAmt
    var status:Int // status
    var statusDes:String //statusDes
    var time:Date // withdrawTime
    
    override init(json: JSON) {
        address = json["toAddressAlias"].stringValue
        txid = json["txid"].stringValue
        amt = json["withdrawAmt"].doubleValue
        status = json["status"].intValue
        statusDes = json["statusDes"].stringValue
        let ts = json["withdrawTime"].doubleValue/1000
        time = Date(timeIntervalSince1970: ts)
        super.init(json: json)
    }
    
    static func historyArrayFrom(json:JSON) -> [BBWithdrawHistory]{
        var array = [BBWithdrawHistory]()
        for js in json.arrayValue{
            array.append(BBWithdrawHistory(json: js))
        }
        return array
    }
}
