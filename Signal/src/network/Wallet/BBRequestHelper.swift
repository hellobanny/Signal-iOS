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
        if js["code"].int == BBCommon.NetCodeSuccess {
            return (js["data"],js["cid"].string)
        }
        else{
            let code = js["code"].int ?? -1
            let warn = UIAlertController(title: "Error Code \(code)", message: js["message"].string, preferredStyle: .alert)
            warn.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            UIApplication.shared.frontmostViewController?.present(warn, animated: true, completion: nil)
        }
        return (nil,nil)
    }
    
    static func showError(error:Error){
        
    }
}
