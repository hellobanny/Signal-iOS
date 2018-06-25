//
//  BBRequestHelper.swift
//  Signal
//
//  Created by 张忠 on 2018/6/15.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class BBRequestHelper: NSObject {
    
    //当解析
    @discardableResult static func parseSuccessResult(object:Any) -> (JSON?,String?){
        print(object)
        let js = JSON(object)
        let code = js["code"].intValue
        if code == BBCommon.NetCodeSuccess {
            return (js["data"],js["cid"].string)
        }
        else{
            BBCommon.notice(title: "Error Code \(code)", message: js["message"].string)
        }
        return (nil,nil)
    }
    
    static func parseCodeOnly(object:Any) -> Int{
        let js = JSON(object)
        return js["code"].intValue
    }
    
    static func showError(error:Error){
        BBCommon.notice(title: "Error", message: error.localizedDescription)
    }
}
