//
//  InputPaywordVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/13.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import PopupDialog

protocol InputPaywordDelegate {
    func passwordInputed(password:String)
}

class InputPaywordVC: UIViewController {
    
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var dotArray = [UIView]()
    var delegate:InputPaywordDelegate?
    
    var titleStr:String!
    var hint:String!
    var value:String!
    
    convenience init(title:String,hint:String,value:String){
        self.init()
        self.titleStr = title
        self.hint = hint
        self.value = value
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldPassword.becomeFirstResponder()
        initTextFieldPwd()
        labelTitle.text = titleStr
        labelHint.text = hint
        labelValue.text = value
    }
    
    func initTextFieldPwd(){
        let width:CGFloat = 42.0
        let dotWidth:CGFloat = 10.0
        let boardColor = UIColor.gray
        for i in 0 ..< 5{
            let pos = CGRect(x: width * CGFloat(i + 1) , y: 0, width: 1, height: width)
            let line = UIView(frame: pos)
            line.backgroundColor = boardColor
            textFieldPassword.addSubview(line)
        }
        let dx = (width - dotWidth)/2.0
        for i in 0 ..< 6 {
            let pos = CGRect(x: width * CGFloat(i) + dx , y: dx, width: dotWidth, height: dotWidth)
            let dot = UIView(frame: pos)
            dot.backgroundColor = UIColor.black
            dot.layer.cornerRadius = dotWidth/2.0
            dot.clipsToBounds = true
            dot.isHidden = true
            textFieldPassword.addSubview(dot)
            dotArray.append(dot)
        }
        textFieldPassword.tintColor = UIColor.clear
        textFieldPassword.textColor = UIColor.clear
        textFieldPassword.layer.borderColor = boardColor.cgColor
        textFieldPassword.layer.borderWidth = 1
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        let c = textFieldPassword.text?.count ?? 0
        for (i,v) in dotArray.enumerated(){
            v.isHidden = i >= c
        }
        if c == 6 {
            self.dismiss(animated: true) {
                self.delegate?.passwordInputed(password: self.textFieldPassword.text!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeSelf(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    static func displayInputPayword(home:UIViewController,delegate:InputPaywordDelegate,title:String,hint:String,value:String){
        let vc = InputPaywordVC(title: title, hint: hint, value: value)
        vc.delegate = delegate
        let pd = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: true, completion: nil)
        home.present(pd, animated: true, completion: nil)
    }

}

extension InputPaywordVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return (textField.text?.count ?? 0) < 6 || range.length == 1
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
