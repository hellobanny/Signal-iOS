//
//  RedPocketAck.swift
//  Signal
//
//  Created by 张忠 on 2018/7/16.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class RedPocketAck: NSObject {
    static let kID = "tID"
    static let kSender = "sender"
    static let kReceiver = "receiver"
    
    var tID:String! //对应的红包ID
    var sender:String! //发红包的人
    var receiver:String! //收红包的人
    
    @objc
    static func loadFrom(string:String) -> RedPocketAck?{
        let json = JSON(parseJSON: string)
        if json[kID].string != nil {
            let rp = RedPocketAck()
            rp.tID = json[kID].stringValue
            rp.sender = json[kSender].stringValue
            rp.receiver = json[kReceiver].stringValue
            return rp
        }
        return nil
    }
    
    @objc func getJsonString() -> String{
        var json = JSON()
        json[RedPocketAck.kID].string = tID
        json[RedPocketAck.kSender].string = sender
        json[RedPocketAck.kReceiver].string = receiver
        return json.rawString() ?? json.stringValue
    }
    
    @objc
    func redPocketDes(my:String) -> String?{
        //你领取了自己发的红包
        //你领取了XX的红包
        //XX领取了你的红包
        if my == sender && my == receiver {
            return "你领取了自己发的红包"
        }
        else if my == sender {
            var name = receiver
            if let cm = Environment.current().contactsManager{
                name = cm.contactOrProfileName(forPhoneIdentifier: receiver)
            }
            return String(format:"%s领取了你的红包",name)
        }
        else if my == receiver {
            var name = sender
            if let cm = Environment.current().contactsManager{
                name = cm.contactOrProfileName(forPhoneIdentifier: sender)
            }
            return String(format:"你领取了%s的红包",name)
        }
        return nil
    }
}
