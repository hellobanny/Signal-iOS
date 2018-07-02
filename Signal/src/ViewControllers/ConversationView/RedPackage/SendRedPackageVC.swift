//
//  SendRedPackageVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/2.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class SendRedPackageVC: UIViewController {

    @IBOutlet weak var buttonChooseCur: UIButton!
    
    @IBOutlet weak var valueBackground: UIView!
    @IBOutlet weak var valueTitle: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var buttonSend: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func userChooseCurrency(_ sender: Any) {
    }
    @IBAction func startSend(_ sender: Any) {
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
