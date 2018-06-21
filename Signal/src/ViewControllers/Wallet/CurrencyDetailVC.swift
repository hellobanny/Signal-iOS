//
//  CurrencyDetailVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/8.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    var cid:String! //进入前先设置
    var currency:BBCurrency?
    
    convenience init(cid:String){
        self.init()
        self.cid = cid
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "历史明细", style: .done, target: self, action: #selector(CurrencyDetailVC.viewCurrencyHistory))
        loadCurrencyDetail()
    }
    
    func loadCurrencyDetail(){
        guard let mycid = cid else {
            return
        }
        let request = BBRequestFactory.shared.memberAsset(cid: mycid)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let detail = res{
                    self.currency = BBCurrency.currencyFrom(json: detail)
                    self.updateImageAndLabels()
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
    
    func updateImageAndLabels(){
        guard let cc = currency else {
            return
        }
        if cc.cid != self.cid {
            return
        }
        let url = URL(string: cc.iconURL)
        imgIcon.kf.setImage(with: url)
        labelName.text = cc.name
        guard let price = cc.price else {
            return
        }
        guard let number = cc.balance else {
            return
        }
        labelPrice.text = BBCurrency.goodPrice(value: price)
        labelNumber.text = BBCurrency.goodNumber(value: number)
        labelTotal.text = BBCurrency.goodPrice(value: price * number)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func viewCurrencyHistory(){
        let his = CurrencyHistoryTC(cid: cid, type: .all)
        self.navigationController?.pushViewController(his, animated: true)
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
        if let address = self.currency?.waddress {
            let sqv = ScanAndQRCodeVC(cid: cid, address: address, isScan: scan)
            sqv.scanAddressDelegate = self
            let nav = UINavigationController(rootViewController: sqv)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func startDeposit(_ sender: Any) {
        if let address = self.currency?.waddress{
            let vc = DepositVC(nibName: "DepositVC", bundle: nil)
            vc.address = address
            vc.cid = cid
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func startWithdraw(_ sender: Any) {
        let vc = WithdrawVC(cid: cid, balance: self.currency?.balance ?? 0.0)
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
        let request = BBRequestFactory.shared.qrcodeAttr(address: text)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let js = res {
                    //是否是平台用户
                    let isOurPlatform = (js["platformMark"].int ?? 0) == 1
                    
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
}

