//
//  GPResultHeader.swift
//  Signal
//
//  Created by 张忠 on 2018/7/13.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SnapKit

class GPResultHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var avatarIV:UIImageView!
    var nameLabel:UILabel!
    var msgLabel:UILabel!
    var valueLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        
        let av = UIImageView(frame: frame)
        self.addSubview(av)
        av.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerX.equalTo(self).offset(0)
            make.top.equalTo(self).offset(32)
        }
        avatarIV = av
        
        let nlb = UILabel()
        self.addSubview(nlb)
        nlb.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(24)
            make.top.equalTo(avatarIV).offset(16)
        }
        nlb.textAlignment = .center
        nlb.toMiddleLabel()
        nameLabel = nlb
        
        let mlb = UILabel()
        self.addSubview(mlb)
        mlb.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(24)
            make.top.equalTo(nameLabel).offset(16)
        }
        mlb.textAlignment = .center
        mlb.toMiddleLabel()
        msgLabel = mlb
        
        let vlb = UILabel()
        self.addSubview(vlb)
        vlb.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(24)
            make.top.equalTo(msgLabel).offset(16)
        }
        vlb.textAlignment = .center
        vlb.toMiddleLabel()
        valueLabel = vlb
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func update(gp:GroupPocket){
        avatarIV.image = gp.sender.avatar
        nameLabel.text = gp.sender.name + "的红包"
        msgLabel.text = gp.message
        valueLabel.text = BBCurrencyCache.shared.getValueString(cid: gp.currency.cid, value: gp.robed)
    }
}
