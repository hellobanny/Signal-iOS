//
//  TransferAcceptVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/29.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

protocol TransferAcceptDelegate {
    func userAccept(operation:OperationMessage)
}

class TransferAcceptVC: UIViewController {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    var operation:OperationMessage!
    var delegate:TransferAcceptDelegate?
    
    convenience init(operation:OperationMessage){
        self.init()
        self.operation = operation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认转账"
        valueLabel.text = BBCurrencyCache.shared.getValueString(cid: operation.currencyType, value: operation.value)
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .short
        timeLabel.toSmallLabel()
        self.timeLabel.text = "转账时间: " + df.string(from: operation.time)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func accept(_ sender: Any) {
        self.delegate?.userAccept(operation: self.operation)
        self.navigationController?.popViewController(animated: true)
    }
    
}
