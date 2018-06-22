//
//  WithdrawHelper.swift
//  Signal
//
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class WithdrawHelper: NSObject, InputPaywordDelegate {
    
    var baseVC:UIViewController!
    var address:String!
    var balance:String!
    var cid:String!
    
    static let shared : WithdrawHelper = {
        let instance = WithdrawHelper()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    func startWithdraw(home:UIViewController,currId:String,toAddress:String,value:String){
        baseVC = home
        address = toAddress
        balance = value
        cid = currId
        prepareAndShow()
    }
    
    func prepareAndShow(){
        let title = "输入交易密码"
        let hint = "转账"
        InputPaywordVC.displayInputPayword(home: baseVC, delegate: self,title: title,hint: hint,value: balance)
    }

    func passwordInputed(password: String) {
        //开始转币
        let request = BBRequestFactory.shared.withdrawDo(cid: cid, toAddress: address, amt: balance, token: password)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            //这里需要自己分析错误值
            if let res = obj {
                print(res)
                if let code = JSON(res)["code"].int{
                    if code == BBCommon.NetCodeSuccess {
                        self.baseVC.dismiss(animated: true, completion: nil)
                        self.showNotice(title: "转账成功")
                    }
                    else if code == BBCommon.NetCodeBalaceLess {
                        self.showNotice(title: "余额不足")
                    }
                    else if code == BBCommon.NetCodeAddressError {
                        self.showNotice(title: "地址错误")
                    }
                    else if code == BBCommon.NetCodePaywordError {//可重新输入密码
                        let av = UIAlertController(title: "字符密码错误", message: nil, preferredStyle: .alert)
                        av.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        av.addAction(UIAlertAction(title: "重新输入", style: .default, handler: { (_) in
                            self.prepareAndShow()
                        }))
                        self.baseVC.present(av, animated: true, completion: nil)
                    }
                    else if code == BBCommon.NetCodeAccountLocked {
                        self.showNotice(title: "账号已经被锁定")
                    }
                    else if code == BBCommon.NetCodePaywordUnset {
                        self.showNotice(title: "字符密码未设置")
                    }
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
    
    func showNotice(title:String){
        let av = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.baseVC.present(av, animated: true, completion: nil)
    }
}
