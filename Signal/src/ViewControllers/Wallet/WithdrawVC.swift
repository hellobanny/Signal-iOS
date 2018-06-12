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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(WithdrawVC.close))
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
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
    }
    
    @IBAction func withdrawAll(_ sender: Any) {
        
    }
    
    @IBAction func startWithdraw(_ sender: Any) {
        
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
