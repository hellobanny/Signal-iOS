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
        let param:[String:Any] = ["cid":cid,"toAddress":toAddress,"transferAmt":amt,"authorizeToken":token]
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
    
    //查看用户是否设置过交易密码
    func authorizetokenSetted() -> TSRequest{
        let path = PATH + "/member/authorizetoken/check"
        let param = [String:Any]()
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取平台参数配置
    func configGet(name:String) -> TSRequest{
        let path = PATH + "/public/config/get"
        let param:[String:Any] = ["name":name]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
}


//MARK: 红包转账相关
extension BBRequestFactory{
    //会话中给用户转账或发红包
    func transferFromSession(to:String,cid:String,type:String,value:String,note:String,payword:String) -> TSRequest{
        let path = PATH + "/member/transfer/fromSession"
        let param:[String:Any] = ["transferTo":to,"cid":cid,"type":type,"volume":value,"note":note,"authorizeToken":payword]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //确认收款
    func transferConfirm(tid:String) -> TSRequest{
        let path = PATH + "/member/transfer/confirm"
        let param:[String:Any] = ["transferId":tid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //查看转账状态
    func transferStatus(tid:String) -> TSRequest{
        let path = PATH + "/member/transfer/status/get"
        let param:[String:Any] = ["transferId":tid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //创建红包
    func envelopeAdd(groupId:String,cid:String,random:Bool,amount:String,count:Int,note:String,payword:String) -> TSRequest{
        let path = PATH + "/envelope/add"
        let param:[String:Any] = ["groupId":groupId,"cid":cid,"type":random ? 2 : 1,"count":count,"amount":amount,"note":note,"authorizeToken":payword]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //获取红包信息
    func envelopeInfoGet(eid:String) -> TSRequest{
        let path = PATH + "/envelope/info/get"
        let param:[String:Any] = ["envelopeId":eid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //抢群红包
    func envelopeRob(eid:String) -> TSRequest{
        let path = PATH + "/envelope/rob"
        let param:[String:Any] = ["envelopeId":eid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //群红包获取发送者信息
    func envelopeSenderinfo(eid:String) -> TSRequest{
        let path = PATH + "/envelope/senderinfo/get"
        let param:[String:Any] = ["envelopeId":eid]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //抢群红包后留言
    func envelopeMessageSave(dataId:String,message:String) -> TSRequest{
        let path = PATH + "/envelope/message/save"
        let param:[String:Any] = ["dataId":dataId,"message":message]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
}

//MARK: 通讯录相关
extension BBRequestFactory{
    //获取我的好友列表
    func friendGet(page:Int,size:Int) -> TSRequest{
        let path = PATH + "/friend/get"
        let param:[String:Any] = ["pageNo":page,"pageSize":size]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //上传我的通讯录信息
    func friendAddressBookUpload(contacts:[String:String]) -> TSRequest{
        let path = PATH + "/friend/addresslist/upload"
        var array = [[String:String]]()
        for (k,v) in contacts{
            let d:[String:String] = ["name":k,"phone":v]
            array.append(d)
        }
        let param:[String:Any] = ["friends":array]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //申请加好友
    func friendApply(phone:String,note:String) -> TSRequest{
        let path = PATH + "/friend/apply"
        let param:[String:Any] = ["phone":phone,"note":note]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //查找好友
    func friendSearch(phone:String) -> TSRequest{
        let path = PATH + "/friend/search"
        let param:[String:Any] = ["phone":phone]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //申请加我为好友的列表
    func friendApplyList(dataTime:Int) -> TSRequest{
        let path = PATH + "/friend/applyList/get"
        let param:[String:Any] = ["dataTime":dataTime]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //处理好友申请记录
    func friendApplyProcess(dataId:String,operation:Int,nickName:String) -> TSRequest{
        let path = PATH + "/friend/apply/process"
        let param:[String:Any] = ["dataId":dataId,"operation":operation,"nickName":nickName]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //好友推荐列表
    func friendRecommend(page:Int,size:Int) -> TSRequest{
        let path = PATH + "/friend/recommend/list"
        let param:[String:Any] = ["pageNo":page,"pageSize":size]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //删除好友关系
    func friendDelete(dataId:String) -> TSRequest{
        let path = PATH + "/friend/delete"
        let param:[String:Any] = ["dataId":dataId]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
}

//MARK: 群关系相关
extension BBRequestFactory{
    //创建群
    func groupAdd(name:String,phones:[String]) -> TSRequest{
        let path = PATH + "/group/add"
        var str = phones.first ?? ""
        for i in 1 ..< phones.count{
            str += ",\(phones[i])"
        }
        let param:[String:Any] = ["name":name,"phones":str]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //群成员列表
    func groupMembers(groupId:String,page:Int,size:Int) -> TSRequest{
        let path = PATH + "/group/members/get"
        let param:[String:Any] = ["groupId":groupId,"pageNo":page,"pageSize":size]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //设置群
    func groupExit(groupId:String,name:String) -> TSRequest{
        let path = PATH + "/group/update"
        let param:[String:Any] = ["groupId":groupId,"name":name]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //被邀请加入群
    func groupJoin(groupId:String,phone:String) -> TSRequest{
        let path = PATH + "/group/join"
        let param:[String:Any] = ["groupId":groupId,"phone":phone]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    
    //踢出群
    func groupKickoff(groupId:String,memberId:String) -> TSRequest{
        let path = PATH + "/group/kickoff"
        let param:[String:Any] = ["groupId":groupId,"memberId":memberId]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
    //退出群
    func groupExit(groupId:String) -> TSRequest{
        let path = PATH + "/group/exit"
        let param:[String:Any] = ["groupId":groupId]
        return TSRequest(url: URL(string: path), method: "POST", parameters: param)
    }
}

