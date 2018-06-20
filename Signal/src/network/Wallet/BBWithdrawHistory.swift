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
    
    override init(json: JSON) {
        address = json["toAddressAlias"].string!
        txid = json["txid"].string!
        amt = json["withdrawAmt"].double!
        status = json["status"].int!
        statusDes = json["statusDes"].string!
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
