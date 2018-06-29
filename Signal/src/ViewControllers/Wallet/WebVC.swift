//
//  WebVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/26.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class WebVC: UIViewController {

    @IBOutlet weak var mywebview: UIWebView!
    
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let ur = url {
            if let u = URL(string: ur) {
                let request = URLRequest(url: u)
                mywebview.loadRequest(request)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
