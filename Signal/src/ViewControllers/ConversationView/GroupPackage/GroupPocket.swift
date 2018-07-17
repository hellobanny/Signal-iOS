//
//  GroupPocket.swift
//  Signal
//
//  Created by 张忠 on 2018/7/13.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

//抢到的人的信息
struct LuckyGuy {
    var name:String //用户
    var avatarRef:String //用户头像索引
    var dataId:String //数据id
    var amount:String //抢到的量
    var robTime:Date //时间
    var thanks:String //祝福语
    
    static func luckGuy(json:JSON) -> LuckyGuy{
        let n = json["name"].stringValue
        let rAmt = json["robAmount"].stringValue
        let msg = json["message"].stringValue
        let dId = json["dataId"].stringValue
        let time = json["robTime"].intValue
        let date = Date(timeIntervalSince1970: Double(time/1000))
        let ref = json["avatar"].stringValue
        return LuckyGuy(name: n, avatarRef: ref, dataId: dId, amount: rAmt, robTime: date, thanks: msg)
    }
}

//红包的数据结构
struct GroupPocket {
    var status:Int //状态
    var count:Int  //总红包数
    var robCount:Int //已抢红包数
    var message:String //祝福语
    var luckyGuys:[LuckyGuy] //抢到的人列表
    var currency:BBCurrency //币种
    var robed:String //你抢到的
    var total:String //总币值
    var sender:BBContact //发红包的
    var type:Int //红包类型
    
    static func loadFrom(json:JSON) -> GroupPocket{
        let st = json["status"].intValue
        let count = json["count"].intValue
        let robCount = json["robCount"].intValue
        let message = json["note"].stringValue
        let cid = json["cid"].stringValue
        let robed = json["selfRobAmt"].stringValue
        let total = json["envelopeAmt"].stringValue
        let type = json["type"].intValue
        let phone = json["senderPhone"].stringValue
        let name = json["senderName"].stringValue
        let avatar = json["senderAvatar"].stringValue
        let sender = BBContact(phone: phone, namep: name, ref: avatar)
        
        var guys = [LuckyGuy]()
        let sj = json["robDataList"]
        for js in sj.arrayValue{
            let guy = LuckyGuy.luckGuy(json: js)
            guys.append(guy)
        }
        let cur = BBCurrencyCache.shared.getCurrencyby(cid: cid)
        return GroupPocket(status: st, count: count, robCount: robCount, message: message, luckyGuys: guys, currency: cur!, robed: robed, total: total, sender: sender, type: type)
    }
}
