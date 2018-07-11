//
//  OperationMessage.swift
//  Signal
//
//  Created by 张忠 on 2018/7/3.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

enum OperationType:String {
    case transfer = "2"
    case redPocket = "3"
    case groupRedP = "4"
    case transferDone = "102"
    case redPocketDone = "103"
    
    func typeName() -> String{
        switch self {
        case .redPocket:
            return "红包"
        case .groupRedP:
            return "群红包"
        case .transferDone:
            return "确认转账"
        case .redPocketDone:
            return "红包已领取"
        default:
            return "转账"
        }
    }
}

@objc
class OperationMessage: NSObject {
    static let kType = "type"
    static let kCurrency = "cType"
    static let kValue = "value"
    static let kMessage = "msg"
    static let kTransferID = "tID"
    static let kTotalNumber = "num"
    static let kTime = "time"
    static let kPicked = "picked"
    
    var type:OperationType = .transfer //类型，
    var currencyType:String! //币种ID
    var value:String! //数量
    var message:String! //附言
    var transferID:String! //红包ID
    var totalNumber:Int = 1
    var time:Date!
    @objc
    var picked:Bool = false

    @objc
    static func loadFrom(string:String) -> OperationMessage?{
        let json = JSON(parseJSON: string)
        if json[kType].string != nil {
            let op = OperationMessage()
            op.type = OperationType(rawValue: json[kType].stringValue) ?? .transfer
            op.currencyType = json[kCurrency].stringValue
            op.value = json[kValue].stringValue
            op.message = json[kMessage].stringValue
            op.transferID = json[kTransferID].stringValue
            op.totalNumber = json[kTotalNumber].intValue
            op.time = Date(timeIntervalSince1970: json[kTime].doubleValue)
            op.picked = json[kPicked].boolValue
            return op
        }
        return nil
    }
    
    @objc func getMessageString() -> String{
        var json = JSON()
        json[OperationMessage.kType].string = type.rawValue
        json[OperationMessage.kCurrency].string = currencyType
        json[OperationMessage.kValue].string = value
        json[OperationMessage.kMessage].string = message
        json[OperationMessage.kTransferID].string = transferID
        json[OperationMessage.kTotalNumber].string = "\(totalNumber)"
        let v = time.timeIntervalSince1970
        json[OperationMessage.kTime].string = String(format: "%.0f", v)
        json[OperationMessage.kPicked].boolValue = picked
        return json.rawString() ?? json.stringValue
    }
    
    @objc
    static let exampleMessage = "{ \"type\":\"2\",\"cType\":\"100\",\"value\":\"100.0\",\"msg\":\"hello world\",\"tID\":\"29394\",\"num\":\"1\"}"
    
    @objc
    func operationDes() -> String{
        return self.type.typeName()
    }
}
