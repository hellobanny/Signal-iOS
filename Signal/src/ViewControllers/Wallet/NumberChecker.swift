//
//  NumberChecker.swift
//  Signal
//
//  Created by 张忠 on 2018/6/21.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class NumberChecker: NSObject {
    static func checkInputNumber(textField:UITextField, string:String) -> Bool{
        if string == "." {
            if textField.text?.contains(".") ?? false{
                return false
            }
            else if textField.text?.isEmpty ?? true{
                textField.text = "0"
                return true
            }
        }
        else if string == "0" {
            if textField.text == "0"{
                return false
            }
        }
        return true
    }
    
    static func isGoodNumber(string:String) -> (Bool,Double?){
        if let v = Double(string){
            return (v > 0,v)
        }
        return (false,nil)
    }
}
