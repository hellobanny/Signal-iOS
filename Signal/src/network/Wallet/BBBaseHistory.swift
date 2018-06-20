//
//  BBBaseHistory.swift
//  Signal
//
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class BBBaseHistory : NSObject {
    var dataID:String //dataId
    var name:String //currName
    var time:Date // tradeTime
    var pageTime:Int //dataTime  用于分页
    
    init(json:JSON) {
        dataID = json["dateId"].string!
        name = json["currName"].string!
        let ts = json["tradeTime"].double ?? 0
        time = Date(timeIntervalSince1970: ts)
        pageTime = json["dataTime"].int!
        super.init()
    }
}
