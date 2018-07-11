//
//  SenderRedPackageDetailVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/2.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class SenderRedPackageDetailVC: UIViewController {

    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    
    var operation:OperationMessage!
    
    convenience init(operation:OperationMessage){
        self.init()
        self.operation = operation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "红包详情"
        labelTitle.text = BBCurrencyCache.shared.getValueString(cid: operation.currencyType, value: operation.value)
        labelDetail.text = operation.message
        
        labelComment.toSmallLabel()
        if operation.picked {
            labelStatus.text = "已领取"
            let df = DateFormatter()
            df.timeStyle = .short
            df.dateStyle = .short
            self.labelComment.text = "发送时间: " + df.string(from: operation.time)
        }
        else {
            labelStatus.text = "未领取"
            labelComment.text = "未领取的红包，将于24小时后发起退款"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryTransferStatus(){
        let request = BBRequestFactory.shared.transferStatus(tid: operation.transferID)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    if let st = cus["status"].int {//正确获得了transferId
                        if st == 1{
                            self.labelStatus.text = "待确认"
                        }
                        else if st == 10{
                            self.labelStatus.text = "已确认"
                        }
                        else if st == 20{
                            self.labelStatus.text = "已过期"
                        }
                    }
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }


}
