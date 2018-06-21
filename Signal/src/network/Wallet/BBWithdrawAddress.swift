//
//  BBWithdrawAddress.swift
//  Signal
//
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class BBWithdrawAddress: NSObject {
    var id:String
    var name:String
    var address:String
    
    init(dId:String,pname:String,paddress:String) {
        id = dId
        name = pname
        address = paddress
        super.init()
    }
    
    init(json:JSON) {
        id = json["dateId"].stringValue
        name = json["toAddressAlias"].stringValue
        address = json["toAddress"].stringValue
        super.init()
    }
    
    static func addressArrayFrom(json:JSON) -> [BBWithdrawAddress]{
        var array = [BBWithdrawAddress]()
        for js in json.arrayValue{
            let cc = BBWithdrawAddress(json: js)
            array.append(cc)
        }
        return array
    }
}
