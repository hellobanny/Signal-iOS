//
//  BBCommon.swift
//  Signal
//
//  Created by 张忠 on 2018/6/20.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

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

    @objc static let ColorGreen = UIColor("#1AAD19")
    @objc static let ColorBlackText = UIColor("#1D2328")
    @objc static let ColorDarkText = UIColor("#A0A6AB")
    @objc static let ColorLightText = UIColor("#C0C9D1")
    @objc static let ColorBackground = UIColor("#F0F0F0")
    @objc static let ColorBlack = UIColor("#1D2328")
    @objc static let ColorWhite = UIColor.white
    @objc static let ColorClickText = UIColor(red:0.30, green:0.39, blue:0.58, alpha:1.00)

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
