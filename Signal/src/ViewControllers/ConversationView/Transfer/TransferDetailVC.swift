//
//  TransferDetailVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/29.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class TransferDetailVC: UIViewController {

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var operation:OperationMessage!
    
    convenience init(operation:OperationMessage){
        self.init()
        self.operation = operation
        timeLabel.toSmallLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "转账详情"
        valueLabel.text = BBCurrencyCache.shared.getValueString(cid: operation.currencyType, value: operation.value)
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .short
        self.timeLabel.text = "时间: " + df.string(from: operation.time)
        queryTransferStatus()
        hintLabel.text = ""
        statusLabel.text = ""
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
                            self.statusLabel.text = "待确认"
                        }
                        else if st == 10{
                            self.statusLabel.text = "已确认"
                        }
                        else if st == 20{
                            self.statusLabel.text = "已过期"
                        }
                    }
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }

}
