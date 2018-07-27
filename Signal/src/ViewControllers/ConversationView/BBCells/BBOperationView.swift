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
        
        let iv = UIImageView(frame: CGRect(x: 8, y: 8, width: 48, height: 48))
        self.addSubview(iv)
        iv.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.left.equalTo(self).offset(8)
            make.top.equalTo(self).offset(8)
        }
        iv.contentMode = .center
        self.iconImageView = iv
        
        let title = UILabel(frame: CGRect(x: 72, y: 8, width: 200, height: 24))
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(72)
            make.top.equalTo(self).offset(8)
            make.height.equalTo(24)
            make.right.equalTo(self).offset(8)
        }
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel = title
        
        let detail = UILabel(frame: CGRect(x: 72, y: 36, width: 200, height: 20))
        self.addSubview(detail)
        detail.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(72)
            make.bottom.equalTo(self).offset(-8)
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
        
        if operation.type == .transfer {
            self.titleLabel.text = BBCurrencyCache.shared.getValueString(cid: operation.currencyType, value: operation.value)
            self.detailLabel.text = (operation.picked ? "已被领取-" : "") + operation.message
            self.iconImageView.image = UIImage(named: "transfer")
        }
        else if operation.type == .transferDone{
            self.titleLabel.text = BBCurrencyCache.shared.getValueString(cid: operation.currencyType, value: operation.value)
            self.detailLabel.text = "已收钱"
            self.iconImageView.image = UIImage(named: "transferDone")
        }
        else if operation.type == .redPocket {
            self.titleLabel.text = operation.message
            self.detailLabel.text = operation.picked ? "红包已领取" : "查看红包"
            self.iconImageView.image = operation.picked ? UIImage(named: "redPocketOpend") : UIImage(named: "redPocketClosed")
        }
        else if operation.type == .redPocketDone{
            self.titleLabel.text = operation.message
            self.detailLabel.text = "红包已领取"
            self.iconImageView.image = UIImage(named: "redPocketOpend")
        }
        else if operation.type == .groupRedP {
            self.titleLabel.text = operation.message
            self.detailLabel.text = operation.picked ? "红包已领取" : "查看红包"
            self.iconImageView.image = operation.picked ? UIImage(named: "redPocketOpend") : UIImage(named: "redPocketClosed")
        }
        self.backgroundColor = operation.picked ? UIColor(red:1.00, green:0.76, blue:0.53, alpha:1.00) : UIColor(red:0.97, green:0.53, blue:0.18, alpha:1.00)
    }
    
}
