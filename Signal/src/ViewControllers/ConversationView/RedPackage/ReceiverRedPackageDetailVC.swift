//
//  ReceiverRedPackageDetailVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/2.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class ReceiverRedPackageDetailVC: UIViewController {

    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    
    var contact:BBContact!
    var operation:OperationMessage!
    
    convenience init(contact:BBContact,operation:OperationMessage){
        self.init()
        self.contact = contact
        self.operation = operation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.toMiddleLabel()
        labelMessage.toMiddleLabel()
        labelValue.toLargeLabel()
        
        self.imageViewAvatar.image = contact.avatar
        self.labelName.text = contact.name
        self.labelMessage.text = operation.message
        self.labelValue.text = BBCurrencyCache.shared.getValueString(cid: operation.currencyType, value: operation.value)
        self.title = "红包"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ReceiverRedPackageDetailVC.close))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
}
