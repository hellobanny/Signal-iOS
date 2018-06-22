//
//  BBCurrencyCache.swift
//  Signal
//
//  Created by 张忠 on 2018/6/21.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class BBCurrencyCache: NSObject {
    
    var currencyDic = [String:BBCurrency]()
    
    static let shared : BBCurrencyCache = {
        let instance = BBCurrencyCache()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    func loadCurrency(){
        let request = BBRequestFactory.shared.platformCurrency()
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    let array = BBCurrency.currencyArrayFrom(json: cus)
                    for cur in array{
                        self.currencyDic[cur.cid] = cur
                    }
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
    
    func getCurrencyby(cid:String) -> BBCurrency? {
        return currencyDic[cid]
    }
}
