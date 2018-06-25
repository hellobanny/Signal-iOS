//
//  WithdrawVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class WithdrawVC: UIViewController {

    @IBOutlet weak var labelChoose: UILabel!
    @IBOutlet weak var buttonChoose: UIButton!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var textFiledNumber: UITextField!
    @IBOutlet weak var labelTip: UILabel!
    @IBOutlet weak var buttonWithdrawAll: UIButton!
    @IBOutlet weak var buttonWithdraw: UIButton!
    
    var cid:String!
    
    var withdrawAddress:BBWithdrawAddress?{
        didSet{
            let title = withdrawAddress?.name ?? "点击选择提现地址"
            buttonChoose.setTitle(title, for: .normal)
            checkButtonStatus()
        }
    }
    
    var balance:Double = 0.0
    var fee:Double = 0.0
    
    convenience init(cid:String,balance:Double,fee:Double){
        self.init()
        self.cid = cid
        self.balance = balance
        self.fee = fee
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(WithdrawVC.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提币历史", style: .done, target: self, action: #selector(WithdrawVC.viewWithdrawHistory))
        buttonWithdraw.isEnabled = false
        buttonChoose.setTitle("点击选择提现地址", for: .normal)
        if let cur = BBCurrencyCache.shared.getCurrencyby(cid: cid){
            labelTip.text = "账户余额:\(balance),手续费\(fee)\(cur.name)"
        }
        self.title = "提币"
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func viewWithdrawHistory(){
        let his = CurrencyHistoryTC(cid: cid, type: .withdraw)
        self.navigationController?.pushViewController(his, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFiledNumber.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseWithdrawAddress(_ sender: Any) {
        let wa = WithdrawAddressTC(cid: cid)
        wa.delegate = self
        self.navigationController?.pushViewController(wa, animated: true)
    }
    
    @IBAction func withdrawAll(_ sender: Any) {
        if balance > fee {
            textFiledNumber.text = "\(balance - fee)"
        }
        else {
            textFiledNumber.text = "0.0"
        }
    }
    
    @IBAction func startWithdraw(_ sender: Any) {
        guard let address = self.withdrawAddress?.address else {
            buttonChoose.layer.shake()
            return
        }
        guard let strNum = self.textFiledNumber.text else{
            textFiledNumber.layer.shake()
            return
        }
        let (good,v) = NumberChecker.isGoodNumber(string: strNum)
        if !good {
            textFiledNumber.layer.shake()
            return
        }
        if v! + fee > balance {
            BBCommon.notice(title: "余额不足")
            return
        }
        WithdrawHelper.shared.startWithdraw(home: self,currId: cid, toAddress: address, value: strNum)
    }
    
    @IBAction func editChaned(_ sender: Any) {
        checkButtonStatus()
    }
    
    func checkButtonStatus(){
        let (good,_) = NumberChecker.isGoodNumber(string: textFiledNumber.text ?? "0")
        buttonWithdraw.isEnabled = withdrawAddress != nil && good
    }
}

extension WithdrawVC : ChooseWithdrawAddressDelegate{
    func chooseWithdraw(address: BBWithdrawAddress) {
        self.withdrawAddress = address
    }
}

extension WithdrawVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return NumberChecker.checkInputNumber(textField: textField, string: string)
    }
}
