//
//  BBOperationView.swift
//  Signal
//  
//  Created by 张忠 on 2018/7/4.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SnapKit

@objc
class BBOperationView: UIView {

    var iconImageView:UIImageView!
    var titleLabel:UILabel!
    var detailLabel:UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let iv = UIImageView(frame: CGRect(x: 8, y: 8, width: 44, height: 44))
        self.addSubview(iv)
        iv.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.left.equalTo(self).offset(8)
            make.top.equalTo(self).offset(8)
        }
        self.iconImageView = iv
        
        let title = UILabel(frame: CGRect(x: 60, y: 8, width: 200, height: 24))
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(60)
            make.top.equalTo(self).offset(8)
            make.height.equalTo(24)
            make.right.equalTo(self).offset(8)
        }
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel = title
        
        let detail = UILabel(frame: CGRect(x: 60, y: 36, width: 200, height: 20))
        self.addSubview(detail)
        detail.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(60)
            make.bottom.equalTo(self).offset(-28)
            make.height.equalTo(20)
            make.right.equalTo(self).offset(8)
        }
        detail.textColor = UIColor.white
        detail.font = UIFont.systemFont(ofSize: 12)
        self.detailLabel = detail
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func config(operation:OperationMessage){
        self.iconImageView.image = UIImage(named: "testRed")
        self.titleLabel.text = "红包"
        self.detailLabel.text = operation.message
    }
    
}
