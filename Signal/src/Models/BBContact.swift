//
//  BBContact.swift
//  Signal
//
//  Created by 张忠 on 2018/7/6.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class BBContact: NSObject {
    var uid:String //phone
    var name:String
    var avatar:UIImage?
    
    init(thread:TSThread) {
        
        uid = thread.contactIdentifier() ?? "Tokenpipe"
        if let cm = Environment.current().contactsManager{
            self.name = cm.contactOrProfileName(forPhoneIdentifier: uid)
            self.avatar = OWSAvatarBuilder.buildImage(thread: thread, diameter: 60, contactsManager: cm)
        }
        else {
            self.name = "Error"
            self.avatar = UIImage(color: UIColor.orange)
        }
        super.init()
    }
    
    init(phone:String,namep:String,photo:UIImage?){
        uid = phone
        name = namep
        avatar = photo
        super.init()
    }
}
