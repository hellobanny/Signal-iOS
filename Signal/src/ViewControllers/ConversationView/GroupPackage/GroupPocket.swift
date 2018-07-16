//
//  GroupPocket.swift
//  Signal
//
//  Created by 张忠 on 2018/7/13.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

//抢到的人的信息
struct LuckyGuy {
    var contact:BBContact //用户
    var dataId:String //数据id
    var amount:String //抢到的量
    var robTime:Date //时间
    var thanks:String //祝福语
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
}
