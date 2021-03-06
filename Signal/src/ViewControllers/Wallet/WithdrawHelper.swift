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
    var indoor = false //indoor 是内部用户转账
    
    static let shared : WithdrawHelper = {
        let instance = WithdrawHelper()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    func startWithdraw(home:UIViewController,currId:String,toAddress:String,value:String,indoor:Bool = false){
        baseVC = home
        address = toAddress
        balance = value
        cid = currId
        self.indoor = indoor
        prepareAndShow()
    }
    
    func prepareAndShow(){
        let title = "输入交易密码"
        let hint = "转账"
        InputPaywordVC.displayInputPayword(home: baseVC, delegate: self,title: title,hint: hint,value: BBCurrencyCache.shared.getValueString(cid: cid, value: balance))
    }

    func passwordInputed(password: String) {
        //开始转币
        let request = indoor ? BBRequestFactory.shared.transferDo(cid: cid, toAddress: address, amt: balance, token: password) : BBRequestFactory.shared.withdrawDo(cid: cid, toAddress: address, amt: balance, token: password)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            //这里需要自己分析错误值
            if let res = obj {
                print(res)
                let code = BBRequestHelper.parseCodeOnly(object: res)
                if code == BBNetCode.success {
                    self.baseVC.dismiss(animated: true, completion: nil)
                    BBCommon.notice(title: "转账成功")
                }
                else if code == BBNetCode.paywordError {//可重新输入密码
                    let av = UIAlertController(title: "字符密码错误", message: nil, preferredStyle: .alert)
                    av.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    av.addAction(UIAlertAction(title: "重新输入", style: .default, handler: { (_) in
                        self.prepareAndShow()
                    }))
                    self.baseVC.present(av, animated: true, completion: nil)
                }
                else {
                    BBCommon.notice(title: code.description())
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
}
