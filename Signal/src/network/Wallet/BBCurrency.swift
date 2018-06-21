//
//  Currency.swift
//  Signal
//
//  Created by 张忠 on 2018/6/15.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

struct BBCurrency {
    var cid:String //cid
    var name:String //currName
    var iconURL:String //symbol
    var balance:Double? //balance
    var price:Double? //marketPrice
    var attention:Int? //attention
    var waddress:String? //waddress
    
    var isAttention:Bool{
        get{
            return attention == 1
        }
        set{
            attention = newValue ? 1 : 0
        }
    }
    
    static func currencyArrayFrom(json:JSON) -> [BBCurrency]{
        var array = [BBCurrency]()
        for js in json.arrayValue{
            if let cc = currencyFrom(json: js){
                array.append(cc)
            }
        }
        return array
    }
    
    static func currencyFrom(json:JSON) -> BBCurrency?{
        let cid = json["cid"].stringValue
        let name = json["currName"].stringValue
        let icon = json["symbol"].stringValue
        let balance = json["balance"].doubleValue
        let price = json["marketPrice"].doubleValue
        let att = json["attention"].intValue
        let add = json["waddress"].stringValue
        let cc = BBCurrency(cid: cid, name: name, iconURL: icon, balance: balance, price: price, attention: att, waddress: add)
        return cc
    }
    
    //返回一个合适的显示价格，至少两个有效数字
    static func goodPrice(value:Double) -> String{
        return "￥" + value.fractionDigits(min: 2, max: 4, roundingMode: NumberFormatter.RoundingMode.halfUp)
    }
    
    static func goodNumber(value:Double) -> String{
        return value.fractionDigits(min: 2, max: 4, roundingMode: NumberFormatter.RoundingMode.halfUp)
    }
}

extension Formatter {
    static let number = NumberFormatter()
}

extension FloatingPoint {
    func fractionDigits(min: Int = 2, max: Int = 2, roundingMode: NumberFormatter.RoundingMode = .halfEven) -> String {
        Formatter.number.minimumFractionDigits = min
        Formatter.number.maximumFractionDigits = max
        Formatter.number.roundingMode = roundingMode
        Formatter.number.numberStyle = .decimal
        return Formatter.number.string(for: self) ?? ""
    }
}
