//
//  HomeViewController.swift
//  Signal
//
//  Created by 张忠 on 2018/7/18.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

@objc
extension HomeViewController:ScanAddressDelegate {
    @objc func loadQRcodeScanVC(scan:Bool){
        if let first = BBCurrencyCache.shared.allCurrencys().first{
            let sqv = ScanAndQRCodeVC(currency: first, isScan: scan)
            sqv.scanAddressDelegate = self
            let nav = UINavigationController(rootViewController: sqv)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func didFinishScan(viewController: ScanAndQRCodeVC, text: String) {
        print("Scan result: \(text)")
        viewController.dismiss(animated: false, completion: nil)
        let request = BBRequestFactory.shared.qrcodeAttr(address: text)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let js = res {
                    //是否是平台用户
                    let isOurPlatform = (js["platformMark"].int ?? 0) == 1
                    //TODO 各种检验
                    let roll = RolloutVC(cid: viewController.currency.cid, address: text, platform: isOurPlatform)
                    let nav = UINavigationController(rootViewController: roll)
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
}
