//
//  ConversationViewController.swift
//  Signal
//
//  Created by 张忠 on 2018/7/4.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

@objc
extension ConversationViewController{
    
    static var lastOperationItem:ConversationViewItem?
    
    @objc func startTransfer(){
        let contact = BBContact(thread: self.thread)
        let inputVC = TransferInputVC(contact: contact)
        inputVC.delegate = self
        let nav = UINavigationController(rootViewController: inputVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func startSendRedPocket(){
        let contact = BBContact(thread: self.thread)
        let inputVC = SendRedPackageVC(contact: contact)
        inputVC.delegate = self
        let nav = UINavigationController(rootViewController: inputVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func startSendGroupPocket(){
        if let gthread = self.thread as? TSGroupThread {
            let inputVC = SendGroupPackageVC(thread: gthread)
            inputVC.delegate = self
            let nav = UINavigationController(rootViewController: inputVC)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func userClickOperationMessage(item:ConversationViewItem){
        if let op = item.operationMessage(){
            let type = item.interaction.interactionType()
            if type == OWSInteractionType.incomingMessage {//收到的
                if op.type == .transfer {//收到的转账,点击确认
                    if op.picked {
                        viewTransferDetail(item: item)
                    }
                    else {
                        checkTransfer(item: item)
                    }
                }
                else if op.type == .transferDone {//收到的转账确认消息
                    viewTransferDetail(item: item)
                }
                else if op.type == .redPocket {//打开红包，如果已经打开，则看详情
                    if op.picked {
                        viewRedPocketDetail(item: item)
                    }
                    else {
                        openRedPocket(item: item)
                    }
                }
                else if op.type == .redPocketDone{
                    viewRedPocketDetail(item: item)
                }
                else if op.type == .groupRedP {
                    self.robOrViewGroupPocket(item: item)
                }
            }
            else if type == OWSInteractionType.outgoingMessage {//自己发的
                if op.type == .transfer {//发起的转账
                    viewTransferDetail(item: item)
                }
                else if op.type == .transferDone {//发起的转账确认
                    viewTransferDetail(item: item)
                }
                else if op.type == .redPocket {//查看红包
                    viewRedPocketDetail(item: item)
                }
                else if op.type == .redPocketDone{
                    viewRedPocketDetail(item: item)
                }
                else if op.type == .groupRedP {
                    self.robOrViewGroupPocket(item: item)
                }
            }
        }
    }
    
    func checkTransfer(item:ConversationViewItem){
        if let op = item.operationMessage() {
            ConversationViewController.lastOperationItem = item
            let acVC = TransferAcceptVC(operation: op)
            acVC.delegate = self
            self.navigationController?.pushViewController(acVC, animated: true)
        }
    }
    
    func viewTransferDetail(item:ConversationViewItem){
        if let op = item.operationMessage() {
            let td = TransferDetailVC(operation: op)
            self.navigationController?.pushViewController(td, animated: true)
        }
    }
    
    func openRedPocket(item:ConversationViewItem){
        if let op = item.operationMessage(){
            ConversationViewController.lastOperationItem = item
            let contact = BBContact(thread: self.thread)
            ReceiveRedPackageVC.displayRedPocket(home: self, delegate: self, contact: contact, operation: op)
        }
    }
    
    func viewRedPocketDetail(item:ConversationViewItem){
        if let op = item.operationMessage() {
            let td = SenderRedPackageDetailVC(operation: op)
            self.navigationController?.pushViewController(td, animated: true)
        }
    }
    
    func makeOperationDone(){
        if let item = ConversationViewController.lastOperationItem{
            self.makeConversationItemPicked(item)
        }
    }
    
    func robOrViewGroupPocket(item:ConversationViewItem){
        //已经抢过的显示详情页面，没有抢过的有两种情况，一种还有剩余，一种没有剩余了。
        if let op = item.operationMessage() {
            //需要先查询红包的情况
            let request = BBRequestFactory.shared.envelopeInfoGet(eid: op.transferID)
            TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                if let result = obj{
                    let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                    if let cus = res {
                        let info = GroupPocket.loadFrom(json: cus)
                        if info.status == 1 && info.robed.isEmpty{//还没抢
                            ConversationViewController.lastOperationItem = item
                            ReceiveRedPackageVC.displayRedPocket(home: self, delegate: self, contact: info.sender, operation: op)
                        }
                        else if info.status == 1 {//已经抢过了
                            let rv = ReceiveGroupPocketDetailVC(groupPocket: info)
                            let nav = UINavigationController(rootViewController: rv)
                            self.present(nav, animated: true, completion: nil)
                        }
                        else {
                            RobToLateVC.displayRobToLate(home: self, groupPocket: info, operation: op)
                        }
                    }
                }
            }) { (task, error) in
                BBRequestHelper.showError(error: error)
            }
        }
    }
}

extension ConversationViewController : TransferInputDelegate{
    func userSend(operation: OperationMessage) {
        self.try(toSendOperationText: operation.getMessageString())
    }
}

extension ConversationViewController : TransferAcceptDelegate {
    func userAccept(operation: OperationMessage) {
        if operation.type == .transfer {
            //接受并发回执
            let request = BBRequestFactory.shared.transferConfirm(tid: operation.transferID)
            TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                if let result = obj{
                    let code = BBRequestHelper.parseCodeOnly(object: result)
                    if code == BBCommon.NetCodeSuccess {
                        //发确认消息
                        let echo = operation.copyAck()
                        self.try(toSendOperationText: echo.getMessageString())
                        self.makeOperationDone()
                    }
                    else {
                        BBCommon.notice(title: "确认收币失败，请重试！")
                    }
                }
            }) { (task, error) in
                BBRequestHelper.showError(error: error)
            }
        }
        else if operation.type == .redPocket {
            let request = BBRequestFactory.shared.transferConfirm(tid: operation.transferID)
            TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                if let result = obj{
                    let code = BBRequestHelper.parseCodeOnly(object: result)
                    if code == BBCommon.NetCodeSuccess {
                        //ZZTODO  要发一条回执消息
                        let echo = operation.copyAck()
                        self.try(toSendOperationText: echo.getMessageString())
                        self.makeOperationDone()
                        let contact = BBContact(thread: self.thread)
                        let detail = ReceiverRedPackageDetailVC(contact: contact, operation: operation)
                        let nav = UINavigationController(rootViewController: detail)
                        self.present(nav, animated: true, completion: nil)
                    }
                    else {
                        BBCommon.notice(title: "确认收币失败，请重试！")
                    }
                }
            }) { (task, error) in
                BBRequestHelper.showError(error: error)
            }
        }
        else if operation.type == .groupRedP {
            let request = BBRequestFactory.shared.envelopeRob(eid: operation.transferID)
            TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                if let result = obj{
                    let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                    if let cus = res {
                        //群发红包先只本地记录抢到，不回复给发送者抢的消息
                        let amount = cus["amount"].stringValue
                        self.makeOperationDone()
                        self.sendRedPocketAck(tID: operation.transferID, sender: operation.sender)
                        
                        let request = BBRequestFactory.shared.envelopeInfoGet(eid: operation.transferID)
                        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                            if let result = obj{
                                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                                if let cus = res {
                                    let info = GroupPocket.loadFrom(json: cus)
                                    let rv = ReceiveGroupPocketDetailVC(groupPocket: info)
                                    let nav = UINavigationController(rootViewController: rv)
                                    self.present(nav, animated: true, completion: nil)
                                }
                            }
                        }) { (task, error) in
                            BBRequestHelper.showError(error: error)
                        }
                    }
                    else {
                        BBCommon.notice(title: "抢红包失败")
                    }
                }
            }) { (task, error) in
                BBRequestHelper.showError(error: error)
            }
        }
    }
    
    func sendRedPocketAck(tID:String,sender:String){
        let ack = RedPocketAck()
        ack.tID = tID
        ack.sender = sender
        ack.receiver = TSAccountManager.localNumber()
        let msg = TSInfoMessage(timestamp: NSDate.ows_millisecondTimeStamp(), in: self.thread, messageType: .redPocketAck, customMessage: ack.getJsonString())
        OWSPrimaryStorage.shared().dbReadWriteConnection.asyncReadWrite { (trans) in
            msg.save(with: trans)
        }
    }
}
