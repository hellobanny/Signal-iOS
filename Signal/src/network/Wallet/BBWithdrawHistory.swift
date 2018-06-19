//
//  BBWithdrawHistory.swift
//  Signal
//
//  Created by 张忠 on 2018/6/19.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

struct BBWithdrawHistory {
    var dataID:String //dataId
    var name:String //currName
    var time:Date // withdrawTime
    var address:String //toAddressAlias
    var txid:String //txid
    var amt:Double //withdrawAmt
    var status:Int // status
    var statusDes:String //statusDes
    var pageTime:Int //dataTime  用于分页
    
    static func historyArrayFrom(json:JSON) -> [BBWithdrawHistory]{
        var array = [BBWithdrawHistory]()
        for js in json.arrayValue{
            if let cc = historyFrom(json: js){
                array.append(cc)
            }
        }
        return array
    }
    
    static func historyFrom(json:JSON) -> BBWithdrawHistory?{
        let id = json["dateId"].string!
        let name = json["currName"].string!
        let ts = json["withdrawTime"].double ?? 0
        let time = Date(timeIntervalSince1970: ts)
        let address = json["toAddressAlias"].string!
        let txid = json["txid"].string!
        let amt = json["withdrawAmt"].double!
        let st = json["status"].int!
        let sts = json["statusDes"].string!
        let dt = json["dataTime"].int!
        return BBWithdrawHistory(dataID: id, name: name, time: time, address: address, txid: txid, amt: amt, status: st, statusDes: sts, pageTime: dt)
    }
}
