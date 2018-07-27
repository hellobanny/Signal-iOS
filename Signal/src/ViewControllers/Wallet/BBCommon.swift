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

    static func notice(title:String,message:String? = nil){
        let av = UIAlertController(title: title, message: message, preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        UIApplication.shared.frontmostViewController?.present(av, animated: true, completion: nil)
    }

    static func changeNavigationBar(vc:UIViewController,isBlack:Bool){
        if isBlack {
            vc.wr_setNavBarBarTintColor(UIColor.bbNavBlack)
            vc.wr_setNavBarTintColor(UIColor.bbNavWhite)
            vc.wr_setNavBarTitleColor(UIColor.bbNavWhite)
            vc.wr_setStatusBarStyle(.lightContent)
        }
        else {
            vc.wr_setNavBarBarTintColor(UIColor.bbNavWhite)
            vc.wr_setNavBarTintColor(UIColor.bbNavBlack)
            vc.wr_setNavBarTitleColor(UIColor.bbNavBlack)
            vc.wr_setStatusBarStyle(.default)
        }
    }
}
