//
//  PasswordHelper.swift
//  Signal
//
//  Created by 张忠 on 2018/6/22.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaywordHelper: NSObject, InputPaywordDelegate {
    
    var isChangePayword = false
    var firstPW:String?
    
    func checkPaywordInited(){
        isChangePayword = false
        let request = BBRequestFactory.shared.authorizetokenSetted()
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    if cus["setFlag"].intValue == 0 {//未设置字符密码
                        self.showIPVC(title: "设置交易密码", hint: "请先设置交易密码，保障安全")
                    }
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
    
    func changePayword(){
        isChangePayword = true
        self.showIPVC(title: "输入旧交易密码", hint: "旧交易密码")
    }
    
    func showIPVC(title:String,hint:String) {
        if let vc = UIApplication.shared.frontmostViewController{
            InputPaywordVC.displayInputPayword(home: vc, delegate: self, title: title, hint: hint, value: "")
        }
    }
    
    func passwordInputed(password: String) {
        if isChangePayword {
            if let fw = firstPW {//新密码
                let request = BBRequestFactory.shared.authorizetokenUpdate(oldToken: fw, newToken: password)
                TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                    if let result = obj{
                        let code = BBRequestHelper.parseCodeOnly(object: result)
                        if code == BBCommon.NetCodeSuccess {
                            BBCommon.notice(title: "交易密码更新成功")
                        }
                        else {
                            BBCommon.notice(title: "交易密码设置失败")
                        }
                    }
                }) { (task, error) in
                    BBRequestHelper.showError(error: error)
                }
            }
            else {
                firstPW = password
                self.showIPVC(title: "输入新交易密码", hint: "新交易密码")
            }
        }
        else {
            if let fw = firstPW {//已输入第二次
                if fw != password {
                    BBCommon.notice(title: "两次输入的密码不同")
                }
                else {
                    let request = BBRequestFactory.shared.authorizetokenSet(token: password)
                    TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                        if let result = obj{
                            let code = BBRequestHelper.parseCodeOnly(object: result)
                            if code == BBCommon.NetCodeSuccess {
                                BBCommon.notice(title: "交易密码设置成功")
                            }
                            else {
                                BBCommon.notice(title: "交易密码设置失败")
                            }
                        }
                    }) { (task, error) in
                        BBRequestHelper.showError(error: error)
                    }
                }
            }
            else {//输入了第一次，再次输入
                firstPW = password
                self.showIPVC(title: "设置交易密码", hint: "请再次输入")
            }
        }
    }
}

