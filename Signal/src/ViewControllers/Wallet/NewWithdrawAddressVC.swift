//
//  NewWithdrawAddressVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class NewWithdrawAddressVC: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var buttonCopy: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func copyClicked(_ sender: Any) {
        tfAddress.text = UIPasteboard.general.string
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfName.becomeFirstResponder()
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
