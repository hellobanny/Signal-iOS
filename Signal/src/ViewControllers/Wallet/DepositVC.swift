//
//  DepositVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import ZXingObjC

class DepositVC: UIViewController {

    @IBOutlet weak var labelManual: UILabel!
    @IBOutlet weak var imageViewAddress: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonCopy: UIButton!
    
    var cid:String!
    
    var address:String!
    
    convenience init(cid:String,address:String){
        self.init()
        self.cid = cid
        self.address = address
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQRCodeImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DepositVC.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "充值记录", style: .done, target: self, action: #selector(DepositVC.viewDepositHistory))
        self.title = "充值"
        self.buttonCopy.tintColor = BBCommon.ColorGreen
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func viewDepositHistory(){
        let his = CurrencyHistoryTC(cid: cid, type: .deposit)
        self.navigationController?.pushViewController(his, animated: true)
    }
    
    func loadQRCodeImage() {
        labelAddress.text = address
        do {
            let writer = ZXMultiFormatWriter()
            let result = try writer.encode(address, format: kBarcodeFormatQRCode, width: 480, height: 480)
            imageViewAddress.image = UIImage(cgImage: ZXImage(matrix: result).cgimage)
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func copyAddress(_ sender: Any) {
        UIPasteboard.general.string = address
        
    }
    
}
