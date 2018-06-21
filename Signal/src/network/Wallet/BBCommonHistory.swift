//
//  BBCommonHistory.swift
//  Signal
//
//  Created by 张忠 on 2018/6/19.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class BBCommonHistory : BBBaseHistory {
    var type:Int // tradeType
    var comment:String //tradeTypeDes
    var abstract:String//tradeAbstract
    
    override init(json: JSON) {
        type = json["tradeType"].intValue
        comment = json["tradeTypeDes"].stringValue
        abstract = json["tradeAbstract"].stringValue
        super.init(json: json)
    }
    
    static func historyArrayFrom(json:JSON) -> [BBCommonHistory]{
        var array = [BBCommonHistory]()
        for js in json.arrayValue{
            let cc = BBCommonHistory(json: js)
            array.append(cc)
        }
        return array
    }
}
