//
//  BBColor.swift
//  Signal
//
//  Created by 张忠 on 2018/7/26.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

extension UIColor{
    @objc class var bbTextBlack:UIColor{
        get { return UIColor("#1D2328") }
    }
    
    @objc class var bbTextDark:UIColor{
        get { return UIColor("#A0A6AB") }
    }
    
    @objc class var bbTextLight:UIColor{
        get { return UIColor("#C0C9D1") }
    }
    
    @objc class var bbTextClick:UIColor{
        get { return UIColor(red:0.30, green:0.39, blue:0.58, alpha:1.00) }
    }
    
    @objc class var bbButtonGreen:UIColor{
        get { return UIColor("#1AAD19") }
    }
    
    @objc class var bbBackGroundGray:UIColor{
        get { return UIColor("#F0F0F0") }
    }
    
    @objc class var bbNavBlack:UIColor{
        get { return UIColor("#1D2328") }
    }
    
    @objc class var bbNavWhite:UIColor{
        get { return UIColor.white }
    }
    
    @objc class var bbMessageOutGreenA:UIColor{
        get { return UIColor(red:0.55, green:0.87, blue:0.28, alpha:1.00) }
    }
    
    @objc class var bbMessageOutGreenB:UIColor{
        get { return UIColor(red:0.48, green:0.77, blue:0.31, alpha:1.00) }
    }
    
    @objc class var bbMessageInWhiteA:UIColor{
        get { return UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00) }
    }
    
    @objc class var bbMessageInWhiteB:UIColor{
        get { return UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00) }
    }
    
    @objc class var bbPocketRedEnable:UIColor{
        get { return UIColor(red:0.89, green:0.29, blue:0.17, alpha:1.00) }
    }
    
    @objc class var bbPocketRedDisable:UIColor{
        get { return UIColor(red:0.89, green:0.69, blue:0.64, alpha:1.00) }
    }
    
    @objc class var bbPocketTextLight:UIColor{
        get { return UIColor(red:0.99, green:0.89, blue:0.59, alpha:1.00) }
    }
    
    @objc class var bbPocketTextDark:UIColor{
        get { return UIColor(red:0.90, green:0.54, blue:0.40, alpha:1.00) }
    }
    
    @objc class var bbActionGreenEnable:UIColor{
        get { return UIColor(red:0.20, green:0.71, blue:0.11, alpha:1.00) }
    }
    
    @objc class var bbActionGreenDisable:UIColor{
        get { return UIColor(red:0.55, green:0.83, blue:0.52, alpha:1.00) }
    }
}
