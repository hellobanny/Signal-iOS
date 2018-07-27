//
//  ScanAndQRCodeVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import ZXingObjC

protocol ScanAddressDelegate {
    func didFinishScan(viewController:ScanAndQRCodeVC,text:String)
}

@objc(ScanAndQRCodeVC)
class ScanAndQRCodeVC: UIViewController {

    @IBOutlet weak var viewQRCode: UIView!
    @IBOutlet weak var buttonToScan: UIButton!
    @IBOutlet weak var imageViewQR: UIImageView!
    
    @IBOutlet weak var labelIconTitle: UILabel!
    @IBOutlet weak var viewScan: UIView!
    @IBOutlet weak var buttonToQRCode: UIButton!

    @objc var isScan:Bool = false
    @IBOutlet weak var imageIcon: UIImageView!
    
    var scanAddressDelegate:ScanAddressDelegate?
    var capture:ZXCapture?
    var isCaptureEnabled = false
    var maskingView:UIView?
    
    var currency:BBCurrency!
    
    convenience init(currency:BBCurrency,isScan:Bool){
        self.init()
        self.currency = currency
        self.checkCurrencyAddress()
        self.isScan = isScan
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ScanAndQRCodeVC.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: currency.name, style: .done, target: self, action: #selector(ScanAndQRCodeVC.switchCurrency))
        self.viewQRCode.backgroundColor = UIColor.bbNavBlack
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func switchCurrency(){
        let cc = ChooseCurrencyTC()
        cc.delegate = self
        self.navigationController?.pushViewController(cc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BBCommon.changeNavigationBar(vc: self, isBlack: true)
        changeMode(scan: isScan)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCapture()
    }
    
    deinit {
        capture?.layer.removeFromSuperlayer()
    }
    
    @discardableResult func checkCurrencyAddress() -> Bool{
        if currency.waddress?.isEmpty ?? true {
            let request = BBRequestFactory.shared.memberAsset(cid: currency.cid)
            TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                if let result = obj{
                    let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                    if let detail = res{
                        if let cur = BBCurrency.currencyFrom(json: detail) {
                            self.currency = cur
                            BBCurrencyCache.shared.update(currency: cur)
                            self.changeMode(scan: self.isScan)
                        }
                    }
                }
            }) { (task, error) in
                BBRequestHelper.showError(error: error)
            }
            return false
        }
        else {
            return true
        }
    }
    
    func changeMode(scan:Bool)
    {
        isScan = scan
        viewQRCode.isHidden = isScan
        viewScan.isHidden = !isScan
        self.title = isScan ? "扫一扫" : "我的二维码"
        if isViewLoaded {
            if isScan{
                loadScanVC()
            }
            else{
                loadQRCodeImage()
            }
        }
    }
    
    func loadQRCodeImage() {
        if let address = currency.waddress {
            if !address.isEmpty {
                do {
                    let writer = ZXMultiFormatWriter()
                    let result = try writer.encode(address, format: kBarcodeFormatQRCode, width: 480, height: 480)
                    imageViewQR.image = UIImage(cgImage: ZXImage(matrix: result).cgimage)
                    if let cur = BBCurrencyCache.shared.getCurrencyby(cid: currency.cid) {
                        self.labelIconTitle.text = cur.name
                        let url = URL(string: cur.iconURL)
                        self.imageIcon.kf.setImage(with: url)
                    }
                } catch {
                    
                }
            }
        }
    }
    
    func loadScanVC() {
        buildMaskImage()
        startCapture()
    }
    
    func startCapture(){
        isCaptureEnabled = true
        if capture == nil {
            DispatchQueue.main.async {
                let cap = ZXCapture()
                cap.camera = cap.back()
                cap.layer.frame = self.viewScan.bounds
                cap.delegate = self
                self.capture = cap
                self.viewScan.layer.insertSublayer(cap.layer, at: 0)
                self.viewScan.bringSubview(toFront: self.maskingView!)
                cap.start()
            }
        }
        else{
            capture?.start()
        }
    }
    
    func stopCapture(){
        isCaptureEnabled = false
        DispatchQueue.main.async {
            self.capture?.stop()
        }
    }
    
    func buildMaskImage(){
        if maskingView == nil {
            let mv = UIImageView(frame: UIScreen.main.bounds)
            self.viewScan.addSubview(mv)
            self.maskingView = mv
            let size = UIScreen.main.bounds.size
            let width = min(size.width,size.height) * 0.67
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(gray: 0.3, alpha: 0.5)
            context?.fill(UIScreen.main.bounds)
            context?.clear(CGRect(x: (size.width - width)/2, y: (size.height - width)/2, width: width, height: width))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            mv.image = img
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchToScan(_ sender: Any) {
        changeMode(scan: true)
    }
    
    @IBAction func switchToShowQRCode(_ sender: Any) {
        changeMode(scan: false)
    }
    
}

extension ScanAndQRCodeVC: ChooseCurrencyDelegate{
    func userChoose(currency: BBCurrency) {
        self.currency = currency
        if self.checkCurrencyAddress() {
            changeMode(scan: isScan)
        }
        self.navigationItem.rightBarButtonItem?.title = currency.name
    }
}

extension ScanAndQRCodeVC:ZXCaptureDelegate{
    func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        self.scanAddressDelegate?.didFinishScan(viewController: self, text: result.text)
    }
    
}
