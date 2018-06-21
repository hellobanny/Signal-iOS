//
//  BBDeposit.swift
//  Signal
//
//  Created by 张忠 on 2018/6/19.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class BBDepositHistory : BBBaseHistory{
    var address:String //fromAddress
    var txid:String //txid
    var amt:Double //chargeAmt
    
    override init(json: JSON) {
        address = json["fromAddress"].stringValue
        txid = json["txId"].stringValue
        amt = json["chargeAmt"].doubleValue
        super.init(json: json)
    }
    
    static func historyArrayFrom(json:JSON) -> [BBDepositHistory]{
        var array = [BBDepositHistory]()
        for js in json.arrayValue{
            array.append(BBDepositHistory(json: js))
        }
        return array
    }
}
