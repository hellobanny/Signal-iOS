//
//  BBCommon.swift
//  Signal
//
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

@objc
class BBCommon: NSObject {
    static let PageSize:Int = 20
    
    
    static let  NetCodeSuccess = 200    //成功
    static let  NetCodeBalaceLess = 90001 //余额不足
    static let  NetCodeAddressError = 90002 //目标地址不存在
    static let  NetCodePaywordError = 90003 //密码错误
    static let  NetCodeAccountLocked = 90004 // 账户已锁定, 30分钟自动解锁
    static let  NetCodePaywordUnset = 90005 //交易密码未设置

    static func notice(title:String,message:String? = nil){
        let av = UIAlertController(title: title, message: message, preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        UIApplication.shared.frontmostViewController?.present(av, animated: true, completion: nil)
    }
    
    @objc static let ColorBlack = UIColor(red:0.20, green:0.22, blue:0.23, alpha:1.00)
    @objc static let ColorWhite = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
    @objc static let ColorDarkText = UIColor(red:0.20, green:0.21, blue:0.22, alpha:1.00)
    @objc static let ColorLightText = UIColor(red:0.61, green:0.63, blue:0.65, alpha:1.00)
    @objc static let ColorGreen = UIColor(red:0.20, green:0.71, blue:0.11, alpha:1.00)
    
    static func changeNavigationBar(vc:UIViewController,isBlack:Bool){
        if isBlack {
            vc.wr_setNavBarBarTintColor(BBCommon.ColorBlack)
            vc.wr_setNavBarTintColor(BBCommon.ColorWhite)
            vc.wr_setNavBarTitleColor(BBCommon.ColorWhite)
            vc.wr_setStatusBarStyle(.lightContent)
        }
        else {
            vc.wr_setNavBarBarTintColor(BBCommon.ColorWhite)
            vc.wr_setNavBarTintColor(BBCommon.ColorBlack)
            vc.wr_setNavBarTitleColor(BBCommon.ColorBlack)
            vc.wr_setStatusBarStyle(.default)
        }
    }
}
