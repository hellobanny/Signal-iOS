//
//  BBRequestFactory.swift
//  Signal
//
//  Created by 张忠 on 2018/6/15.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class BBRequestFactory: NSObject {
    
    static let shared : BBRequestFactory = {
        let instance = BBRequestFactory()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    //获取我关注的币种
    func memberCurrency() -> TSRequest{
        let path = "/member/currency/get"
        let param = [String:Any]()
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //设置我关注的币种
    func currencyAttention(cids:String) -> TSRequest{
        let path = "/member/currency/attention"
        let param:[String:Any] = ["cids":cids]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取所有币种
    func platformCurrency() -> TSRequest{
        let path = "/platform/currency/get"
        let param = [String:Any]()
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取单个币种资产
    func memberAsset(cid:String) -> TSRequest{
        let path = "/member/asset/get/bycid"
        let param:[String:Any] = ["cid":cid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取单个币种所有历史汇总交易列表
    func memberHisTrade(time:Int64,pageSize:Int) -> TSRequest{
        let path = "/member/his/trade/get"
        let param:[String:Any] = ["dateTime":time,"pageSize":pageSize]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取单个币种历史充值列表
    func memberHisCharge(time:Int64,pageSize:Int) -> TSRequest{
        let path = "/member/his/charge/get"
        let param:[String:Any] = ["dateTime":time,"pageSize":pageSize]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取单个币种历史提现列表
    func memberHisWithdraw(time:Int64,pageSize:Int) -> TSRequest{
        let path = "/member/his/withdraw/get"
        let param:[String:Any] = ["dateTime":time,"pageSize":pageSize]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取所有提现地址列表
    func withdrawAddress() -> TSRequest{
        let path = "/member/withdraw/address/get"
        let param = [String:Any]()
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //提现
    func withdrawDo(cid:String,toAddress:String,amt:String,token:String) -> TSRequest{
        let path = "/member/withdraw/do"
        let param:[String:Any] = ["cid":cid,"toAddress":toAddress,"withdrawAmt":amt,"authorizeToken":token]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //添加提现地址
    func withdrawAddressAdd(name:String,address:String) -> TSRequest{
        let path = "/member/withdraw/address/add"
        let param:[String:Any] = ["toAddressAlias":name,"toAddress":address]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }

    //删除提现地址
    func withdrawAddressDel(dataId:String) -> TSRequest{
        let path = "/member/withdraw/address/del"
        let param:[String:Any] = ["dataId":dataId]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //付款转币
    func transferDo(cid:String,toAddress:String,amt:String,token:String) -> TSRequest{
        let path = "/member/transfer/do"
        let param:[String:Any] = ["cid":cid,"toAddress":toAddress,"withdrawAmt":amt,"authorizeToken":token]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取币种的二维码
    func currencyQRCode(cid:String) -> TSRequest{
        let path = "/member/currency/qrcode/get"
        let param:[String:Any] = ["cid":cid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取币种的二维码
    func qrcodeAttr(address:String) -> TSRequest{
        let path = "/public/qrcode/attr/get"
        let param:[String:Any] = ["address":address]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //设置提现密码
    func authorizetokenSet(token:String) -> TSRequest{
        let path = "/member/authorizetoken/set"
        let param:[String:Any] = ["authorizeToken":token]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //修改提现密码
    func authorizetokenUpdate(oldToken:String,newToken:String) -> TSRequest{
        let path = "/member/authorizetoken/update"
        let param:[String:Any] = ["authorizeToken":oldToken,"newAuthorizeToken":newToken]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取平台参数配置
    func configGet(name:String) -> TSRequest{
        let path = "/public/config/get"
        let param:[String:Any] = ["name":name]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    static func getCurrencyList() -> TSRequest{
        
        let path = "/v3/currencylist"
        let param = [String:Any]()
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    func test() {
        let manager = TSNetworkManager.shared()
        let request = BBRequestFactory.getCurrencyList()
        manager.makeRequest(request, success: { (task, objc) in
            
        }) { (task, error) in
            
        }
    }
}
