//
//  RolloutVC.swift
//  Signal
//  转账或转出
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class RolloutVC: UIViewController {
    
    @IBOutlet weak var labelAddressTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelNumberTitle: UILabel!
    @IBOutlet weak var tfInput: UITextField!
    @IBOutlet weak var labelHit: UILabel!
    @IBOutlet weak var buttonPay: UIButton!
    
    var cid:String!
    var address:String!
    var isOurPlatform:Bool = true
    
    convenience init(cid:String,address:String, platform:Bool) {
        self.init()
        self.cid = cid
        self.address = address
        self.isOurPlatform = platform
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonPay.isEnabled = false
        labelAddress.text = address
        labelHit.text = isOurPlatform ? "是平台用户，无需手续费" : "非平台用户，需要0.01ETH手续费"
        tfInput.becomeFirstResponder()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(RolloutVC.close))
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startPay(_ sender: Any) {
        guard let strNum = self.tfInput.text else{
            tfInput.layer.shake()
            return
        }
        let (good,_) = NumberChecker.isGoodNumber(string: strNum)
        if !good {
            tfInput.layer.shake()
            return
        }
        WithdrawHelper.shared.startWithdraw(home: self,currId: cid, toAddress: address, value: strNum)
    }
    
    @IBAction func editChaned(_ sender: Any) {
        let (good,_) = NumberChecker.isGoodNumber(string: tfInput.text ?? "0")
        buttonPay.isEnabled = good
    }
}


extension RolloutVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return NumberChecker.checkInputNumber(textField: textField, string: string)
    }
}
