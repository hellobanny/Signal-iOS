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
    
    var total:Double = 100.0{
        didSet{
            labelTip.text = "账户余额:\(total),手续费0.01ETH"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(WithdrawVC.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提币历史", style: .done, target: self, action: #selector(WithdrawVC.viewWithdrawHistory))
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func viewWithdrawHistory(){
        let his = WithdrawHistoryTC(nibName: "WithdrawHistoryTC", bundle: nil)
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
        let wa = WithdrawAddressTC(nibName: "WithdrawAddressTC", bundle: nil)
        self.navigationController?.pushViewController(wa, animated: true)
    }
    
    @IBAction func withdrawAll(_ sender: Any) {
        textFiledNumber.text = "\(total)"
    }
    
    @IBAction func startWithdraw(_ sender: Any) {
        InputPaywordVC.displayInputPayword(home: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WithdrawVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "." {
            if textField.text?.contains(".") ?? false{
                return false
            }
            else if textField.text?.isEmpty ?? true{
                textField.text = "0"
                return true
            }
        }
        return true
    }
}
