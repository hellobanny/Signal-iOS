//
//  TransferAcceptVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/29.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class TransferAcceptVC: UIViewController {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var hintLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func accept(_ sender: Any) {
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
