//
//  BBCommonHistory.swift
//  Signal
//
//  Created by 张忠 on 2018/6/19.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

struct BBCommonHistory {
    var dataID:String //dataId
    var name:String //currName
    var time:Date // tradeTime
    var type:Int // tradeType
    var description:String //tradeTypeDes
    var abstract:String//tradeAbstract
    var pageTime:Int //dataTime  用于分页
    
    static func historyArrayFrom(json:JSON) -> [BBCommonHistory]{
        var array = [BBCommonHistory]()
        for js in json.arrayValue{
            if let cc = historyFrom(json: js){
                array.append(cc)
            }
        }
        return array
    }
    
    static func historyFrom(json:JSON) -> BBCommonHistory?{
        let id = json["dateId"].string!
        let name = json["currName"].string!
        let ts = json["tradeTime"].double ?? 0
        let time = Date(timeIntervalSince1970: ts)
        let type = json["tradeType"].int!
        let des = json["tradeTypeDes"].string!
        let abs = json["tradeAbstract"].string!
        let dt = json["dataTime"].int!
        return BBCommonHistory(dataID: id, name: name, time: time, type: type, description: des, abstract: abs, pageTime: dt)
    }
}
