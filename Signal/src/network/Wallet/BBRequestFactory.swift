//
//  BBRequestFactory.swift
//  Signal
//
//  Created by 张忠 on 2018/6/15.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class BBRequestFactory: NSObject {
    
    let PATH = "/mekoo"
    
    static let shared : BBRequestFactory = {
        let instance = BBRequestFactory()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    //获取我关注的币种
    func memberCurrency() -> TSRequest{
        let path = PATH + "/member/currency/get"
        let param = [String:Any]()
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //设置我关注的币种
    func currencyAttention(cids:String) -> TSRequest{
        let path = PATH + "/member/currency/attention"
        let param:[String:Any] = ["cids":cids]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取所有币种
    func platformCurrency() -> TSRequest{
        let path = PATH + "/platform/currency/get"
        let param = [String:Any]()
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取单个币种资产
    func memberAsset(cid:String) -> TSRequest{
        let path = PATH + "/member/asset/get/bycid"
        let param:[String:Any] = ["cid":cid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取单个币种所有历史汇总交易列表,币种历史充值列表,币种历史提现列表
    func memberHis(type:BBHistoryType,cid:String,time:Int,pageSize:Int) -> TSRequest{
        var path = ""
        switch type {
        case .deposit:
            path = PATH + "/member/his/charge/get"
            break
        case .withdraw:
            path = PATH + "/member/his/withdraw/get"
            break
        default:
            path = PATH + "/member/his/trade/get"
        }
        let param:[String:Any] = ["dateTime":time,"pageSize":pageSize,"cid":cid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取所有提现地址列表
    func withdrawAddress(cid:String) -> TSRequest{
        let path = PATH + "/member/withdraw/address/get"
        let param:[String:Any] = ["cid":cid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //提现
    func withdrawDo(cid:String,toAddress:String,amt:String,token:String) -> TSRequest{
        let path = PATH + "/member/withdraw/do"
        let param:[String:Any] = ["cid":cid,"toAddress":toAddress,"withdrawAmt":amt,"authorizeToken":token]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //添加提现地址
    func withdrawAddressAdd(cid:String,name:String,address:String) -> TSRequest{
        let path = PATH + "/member/withdraw/address/add"
        let param:[String:Any] = ["toAddressAlias":name,"toAddress":address,"cid":cid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }

    //删除提现地址
    func withdrawAddressDel(dataId:String) -> TSRequest{
        let path = PATH + "/member/withdraw/address/del"
        let param:[String:Any] = ["dataId":dataId]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //付款转币
    func transferDo(cid:String,toAddress:String,amt:String,token:String) -> TSRequest{
        let path = PATH + "/member/transfer/do"
        let param:[String:Any] = ["cid":cid,"toAddress":toAddress,"withdrawAmt":amt,"authorizeToken":token]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取币种的二维码
    func currencyQRCode(cid:String) -> TSRequest{
        let path = PATH + "/member/currency/qrcode/get"
        let param:[String:Any] = ["cid":cid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取币种的二维码
    func qrcodeAttr(address:String) -> TSRequest{
        let path = PATH + "/public/qrcode/attr/get"
        let param:[String:Any] = ["address":address]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //设置提现密码
    func authorizetokenSet(token:String) -> TSRequest{
        let path = PATH + "/member/authorizetoken/set"
        let param:[String:Any] = ["authorizeToken":token]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //修改提现密码
    func authorizetokenUpdate(oldToken:String,newToken:String) -> TSRequest{
        let path = PATH + "/member/authorizetoken/update"
        let param:[String:Any] = ["authorizeToken":oldToken,"newAuthorizeToken":newToken]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取平台参数配置
    func configGet(name:String) -> TSRequest{
        let path = PATH + "/public/config/get"
        let param:[String:Any] = ["name":name]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
   
}
