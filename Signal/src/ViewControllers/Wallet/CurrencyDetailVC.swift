//
//  CurrencyDetailVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/8.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class CurrencyDetailVC: UIViewController {
    
    @IBOutlet weak var imgIcon:UIImageView!
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelPrice:UILabel!
    @IBOutlet weak var labelNumber:UILabel!
    @IBOutlet weak var labelTotal:UILabel!
    @IBOutlet weak var buttonQRCode:UIButton!
    @IBOutlet weak var buttonScan:UIButton!
    @IBOutlet weak var buttonDeposit:UIButton!
    @IBOutlet weak var buttonWithdraw:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMyQRCode(_ sender: Any) {
       loadScanAndQRCodeVC(scan: false)
    }
    
    @IBAction func startScan(_ sender: Any) {
        loadScanAndQRCodeVC(scan: true)
    }
    
    func loadScanAndQRCodeVC(scan:Bool) {
        let sqv = ScanAndQRCodeVC(nibName: "ScanAndQRCodeVC", bundle: nil)
        sqv.isScan = scan
        sqv.scanAddressDelegate = self
        let nav = UINavigationController(rootViewController: sqv)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func startDeposit(_ sender: Any) {
        let vc = DepositVC(nibName: "DepositVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func startWithdraw(_ sender: Any) {
        let vc = WithdrawVC(nibName: "WithdrawVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
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

extension CurrencyDetailVC:ScanAddressDelegate{
    func didFinishScan(viewController: UIViewController, text: String) {
        print("Scan result: \(text)")
        viewController.dismiss(animated: false, completion: nil)
    }
}

