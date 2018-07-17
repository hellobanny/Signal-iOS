//
//  TransferInputVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/29.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

protocol TransferInputDelegate {
    func userSend(operation:OperationMessage)
}

@objc
class TransferInputVC: UIViewController {
    @IBOutlet weak var bigBGView: UIView!
    @IBOutlet weak var smallBGView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buttonChooseCurrency: UIButton!
    @IBOutlet weak var numberTitleLabel: UILabel!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var buttonTransfer: UIButton!
    
    var contact:BBContact!
    var delegate:TransferInputDelegate?
    
    var currency:BBCurrency?{
        didSet{
            if let c = currency{
                if let b = c.balance {
                    buttonChooseCurrency.setTitle("\(c.name) (\(BBNumberFT.shared.goodNumber(value: b)))", for: .normal)
                }
            }
        }
    }
    
    var memo:String?{
        didSet{
            if memo?.isEmpty ?? true {
                let att = NSAttributedString(string: "添加转币说明", attributes: [NSAttributedStringKey.foregroundColor:BBCommon.ColorClickText])
                memoLabel.attributedText = att
            }
            else {
                let att = NSMutableAttributedString(string: memo!, attributes: [NSAttributedStringKey.foregroundColor:BBCommon.ColorLightText])
                let s2 = NSAttributedString(string: " 修改", attributes: [NSAttributedStringKey.foregroundColor:BBCommon.ColorClickText])
                att.append(s2)
                memoLabel.attributedText = att
            }
        }
    }
    
    @objc
    convenience init(contact:BBContact){
        self.init()
        self.contact = contact
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.photoImageView.image = contact.avatar
        self.nameLabel.text = contact.name
        
        nameLabel.toMiddleLabel()
        numberTitleLabel.toSmallLabel()
        buttonTransfer.layer.masksToBounds = true
        buttonTransfer.layer.cornerRadius = 4.0
        
        memoLabel.isUserInteractionEnabled = true
        memoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TransferInputVC.changeMemo)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TransferInputVC.close))
        self.title = "转账给朋友"
        
        self.currency = BBCurrencyCache.shared.allCurrencys().first
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFieldValue.text = ""
        textFieldValue.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseCurrency(_ sender: Any) {
        let cc = ChooseCurrencyTC()
        cc.delegate = self
        self.navigationController?.pushViewController(cc, animated: true)
    }
    
    @IBAction func startTransfer(_ sender: Any) {
        guard let curr = currency else {
            buttonChooseCurrency.layer.shake()
            return
        }
        guard let txt = textFieldValue.text else {
            textFieldValue.layer.shake()
            return
        }
        let (ok,_) = NumberChecker.isGoodNumber(string: txt)
        if !ok {
            textFieldValue.layer.shake()
            return
        }
        
        let title = "输入交易密码"
        let hint = "转账"
        let value = "\(txt) \(curr.name)"
        InputPaywordVC.displayInputPayword(home: self, delegate: self,title: title,hint: hint,value: value)
    }
    
    @objc func changeMemo(){
        let ac = UIAlertController(title: "转币说明", message: nil, preferredStyle: .alert)
        let save = UIAlertAction(title: "确定", style: .default) { (_) in
            let tf = ac.textFields![0]
            self.memo = tf.text
        }
        save.isEnabled = true
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (_) in }
        
        ac.addTextField { (textField) in
            textField.placeholder = "收币方可见，最多20个字"
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                if let txt = textField.text {
                    save.isEnabled = !(txt.isEmpty) && txt.lengthOfBytes(using: String.Encoding.utf8) <= 20
                }
                else {
                    save.isEnabled = false
                }
            }
        }
        ac.addAction(cancel)
        ac.addAction(save)
        self.present(ac, animated: true, completion: nil)
    }
}

extension TransferInputVC: InputPaywordDelegate{
    func passwordInputed(password: String) {
        //用户输入了密码，开始调用协议
        //类型，目标用户，币种，数量，附言和密码
        guard let txt = textFieldValue.text else {
            textFieldValue.layer.shake()
            return
        }
        let (ok,_) = NumberChecker.isGoodNumber(string: txt)
        if !ok {
            textFieldValue.layer.shake()
            return
        }
        let cid = self.currency!.cid
        let request = BBRequestFactory.shared.transferFromSession(to: contact.uid, cid: cid, type: OperationType.transfer.rawValue, value: txt, note: self.memo ?? "", payword: password)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    if let tid = cus["transferId"].string {//正确获得了transferId
                        let op = OperationMessage()
                        op.type = .transfer
                        op.currencyType = cid
                        op.value = txt
                        op.sender = TSAccountManager.localNumber()
                        op.message = self.memo ?? ""
                        op.transferID = tid
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
        self.delegate?.userSend(operation: operation)
        let value = "\(operation.value) \(currency!.name)"
        let resultVC = TransferResultVC(name: contact.name, value: value)
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
}

extension TransferInputVC: ChooseCurrencyDelegate{
    func userChoose(currency: BBCurrency) {
        self.currency = currency
    }
}

extension TransferInputVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return NumberChecker.checkInputNumber(textField: textField, string: string)
    }
}
