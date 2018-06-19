//
//  BBDeposit.swift
//  Signal
//
//  Created by 张忠 on 2018/6/19.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

struct BBDepositHistory {
    var dataID:String //dataId
    var name:String //currName
    var time:Date // tradeTime
    var address:String //fromAddress
    var txid:String //txid
    var amt:Double //chargeAmt
    var pageTime:Int //dataTime  用于分页
    
    static func historyArrayFrom(json:JSON) -> [BBDepositHistory]{
        var array = [BBDepositHistory]()
        for js in json.arrayValue{
            if let cc = historyFrom(json: js){
                array.append(cc)
            }
        }
        return array
    }
    
    static func historyFrom(json:JSON) -> BBDepositHistory?{
        let id = json["dateId"].string!
        let name = json["currName"].string!
        let ts = json["tradeTime"].double ?? 0
        let time = Date(timeIntervalSince1970: ts)
        let address = json["fromAddress"].string!
        let txid = json["txid"].string!
        let amt = json["chargeAmt"].double!
        let dt = json["dataTime"].int!
        return BBDepositHistory(dataID: id, name: name, time: time, address: address, txid: txid, amt: amt, pageTime: dt)
    }
}
