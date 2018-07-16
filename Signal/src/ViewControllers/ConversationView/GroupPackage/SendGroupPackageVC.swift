//
//  SendGroupPackageVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/11.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class SendGroupPackageVC: UIViewController {
    
    @IBOutlet weak var buttonChooseCur: UIButton!
    
    @IBOutlet weak var valueBackground: UIView!
    @IBOutlet weak var valueTitle: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var changeTypeLabel:UILabel!
    
    @IBOutlet weak var numberBackground: UIView!
    @IBOutlet weak var numberTitle: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var buttonSend: UIButton!
    
    var thread:TSGroupThread!
    var delegate:TransferInputDelegate?
    var isRandomRP:Bool = true{
        didSet{
            let s1 = isRandomRP ? "当前为拼手气红包，" : "当前为普通红包，"
            let s2 = isRandomRP ? "改为普通红包" : "改为拼手气红包"
            let att1 = NSMutableAttributedString(string: s1, attributes: [NSAttributedStringKey.foregroundColor:BBCommon.ColorLightText])
            let att2 = NSAttributedString(string: s2, attributes: [NSAttributedStringKey.foregroundColor:BBCommon.ColorClickText])
            att1.append(att2)
            changeTypeLabel.attributedText = att1
            valueTitle.text = isRandomRP ? "🎲总金额" : "单个金额"
        }
    }
    
    var currency:BBCurrency?{
        didSet{
            if let c = currency{
                if let b = c.balance {
                    buttonChooseCur.setTitle("\(c.name) (\(BBNumberFT.shared.goodNumber(value: b)))", for: .normal)
                }
            }
        }
    }
    
    @objc
    convenience init(thread:TSGroupThread){
        self.init()
        self.thread = thread
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViewsRadius(views: [buttonSend,buttonChooseCur,valueBackground,numberBackground,memoTextView])
        
        valueLabel.toLargeLabel()
        memoTextView.text = SendRedPackageVC.defaultMsg
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TransferInputVC.close))
        self.title = "发红包"
        
        self.currency = BBCurrencyCache.shared.allCurrencys().first
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SendRedPackageVC.userTapBgView)))
        isRandomRP = true
        changeTypeLabel.isUserInteractionEnabled = true
        changeTypeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SendGroupPackageVC.userTapChangeType)))
    }
    
    @objc func userTapBgView(){
        self.valueTextField.resignFirstResponder()
        self.memoTextView.resignFirstResponder()
        numberTextField.resignFirstResponder()
    }
    
    @objc func userTapChangeType(){
        isRandomRP = !isRandomRP
    }
    
    func configViewsRadius(views:[UIView]){
        for v in views{
            v.layer.masksToBounds = true
            v.layer.cornerRadius = 4.0
        }
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        valueTextField.text = ""
        valueTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        self.valueLabel.text = self.valueTextField.text
    }
    
    @IBAction func userChooseCurrency(_ sender: Any) {
        let cc = ChooseCurrencyTC()
        cc.delegate = self
        self.navigationController?.pushViewController(cc, animated: true)
    }
    
    @IBAction func startSend(_ sender: Any) {
        guard let curr = currency else {
            buttonChooseCur.layer.shake()
            return
        }
        guard let txt = valueTextField.text else {
            valueTextField.layer.shake()
            return
        }
        let (ok,_) = NumberChecker.isGoodNumber(string: txt)
        if !ok {
            valueTextField.layer.shake()
            return
        }
        
        let title = "输入交易密码"
        let hint = "发红包"
        let value = "\(txt) \(curr.name)"
        InputPaywordVC.displayInputPayword(home: self, delegate: self,title: title,hint: hint,value: value)
    }
    
}

extension SendGroupPackageVC: InputPaywordDelegate{
    func passwordInputed(password: String) {
        //用户输入了密码，开始调用协议
        //类型，目标用户，币种，数量，附言和密码
        guard let txt = valueTextField.text else {
            valueTextField.layer.shake()
            return
        }
        let (ok,_) = NumberChecker.isGoodNumber(string: txt)
        if !ok {
            valueTextField.layer.shake()
            return
        }
        guard let cs = numberTextField.text else {
            numberTextField.layer.shake()
            return
        }
        guard let count = Int(cs) else {
            numberTextField.layer.shake()
            return
        }
        let cid = self.currency!.cid
        let msg = self.memoTextView.text ?? ""
        //群红包的协议
        print(thread.groupModel.groupId)
        let gid = String(data: thread.groupModel.groupId, encoding: .utf8)
        let request = BBRequestFactory.shared.envelopeAdd(groupId: gid! , cid: cid, random: isRandomRP, amount: txt, count: count, note: msg, payword: password)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    if let eid = cus["envelopeId"].string {//正确获得了envelopeId
                        let op = OperationMessage()
                        op.type = OperationType.groupRedP
                        op.currencyType = cid
                        op.value = txt
                        op.message = msg
                        op.transferID = eid
                        op.time = Date()
                        op.picked = false
                        self.delegate?.userSend(operation: op)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
    
    func send(operation:OperationMessage){
        self.dismiss(animated: true) {
            self.delegate?.userSend(operation: operation)
        }
    }
}

extension SendGroupPackageVC: ChooseCurrencyDelegate{
    func userChoose(currency: BBCurrency) {
        self.currency = currency
    }
}

extension SendGroupPackageVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return NumberChecker.checkInputNumber(textField: textField, string: string)
    }
}
