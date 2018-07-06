//
//  TransferResultVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/29.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class TransferResultVC: UIViewController {
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    
    var name:String!
    var value:String!
    
    @objc
    convenience init(name:String,value:String){
        self.init()
        self.name = name
        self.value = value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultLabel.text = "待\(name)确认收币"
        self.valueLabel.text = value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
