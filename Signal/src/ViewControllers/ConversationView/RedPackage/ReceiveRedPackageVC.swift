//
//  ReceiveRedPackageVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/2.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class ReceiveRedPackageVC: UIViewController {
    
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var imageViewAvator: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAction: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var buttonOpen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dialogClose(_ sender: Any) {
        
    }
    
    @IBAction func openRedPackage(_ sender: Any) {
        
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
