//
//  TransferInputVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/29.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

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
    
    var uid:String!
    var name:String!
    var photo:UIImage!
    
    var currency:BBCurrency?{
        didSet{
            if let c = currency{
                if let b = c.balance {
                    buttonChooseCurrency.setTitle("\(c.name)(\(BBNumberFT.shared.goodNumber(value: b)))", for: .normal)
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
    
    convenience init(uid:String,name:String,photo:UIImage){
        self.init()
        self.uid = uid
        self.name = name
        self.photo = photo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.photoImageView.image = photo
        self.nameLabel.text = name
        
        nameLabel.toMiddleLabel()
        numberTitleLabel.toSmallLabel()
        buttonTransfer.layer.masksToBounds = true
        buttonTransfer.layer.cornerRadius = 4.0
        
        memoLabel.isUserInteractionEnabled = true
        memoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TransferInputVC.changeMemo)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            textField.text = "收币方可见，最多20个字"
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
        //TODO 用户输入了密码，开始调用协议
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
