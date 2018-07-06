//
//  BBCurrencyCache.swift
//  Signal
//
//  Created by 张忠 on 2018/6/21.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

@objc
class BBCurrencyCache: NSObject {
    
    var currencyDic = [String:BBCurrency]()
    @objc
    static let shared : BBCurrencyCache = {
        let instance = BBCurrencyCache()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    @objc
    public func loadCurrency(){
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
    
    func allCurrencys() -> [BBCurrency] {
        let array = self.currencyDic.map{$0.value}
        return array
    }
    
    func getCurrencyby(cid:String) -> BBCurrency? {
        return currencyDic[cid]
    }
    
    func getValueString(cid:String,value:String) -> String{
        if let c = currencyDic[cid] {
            return value + " " + c.name
        }
        return value
    }
    
    func update(currency:BBCurrency){
        currencyDic[currency.cid] = currency
    }
}
