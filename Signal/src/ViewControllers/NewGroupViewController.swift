//
//  NewGroupViewController.swift
//  Signal
//
//  Created by 张忠 on 2018/7/13.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

extension NewGroupViewController {
    @objc func createGroupModel(name:String,phones:[String],image:UIImage){
        let request = BBRequestFactory.shared.groupAdd(name: name, phones: phones)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    let groupId = cus["groupId"].stringValue
                    if let gd = groupId.data(using: .utf8){
                        let model = TSGroupModel(title: name, memberIds: phones, image: image, groupId: gd)
                        self.isCreatGroup = false
                        self.createGroup(model)
                    }
                }
            }
        }) { (task, error) in
            self.isCreatGroup = false
            BBRequestHelper.showError(error: error)
        }
    }
}
