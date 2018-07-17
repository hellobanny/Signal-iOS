//
//  HeadViewCell.swift
//  Signal
//
//  Created by 张忠 on 2018/7/17.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class HeadViewCell: UITableViewCell {

    @IBOutlet weak var avatarIV:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var msgLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(sender:BBContact?,message:String,cid:String,robed:String){
        avatarIV.image = sender?.avatar
        nameLabel.text = (sender?.name ?? "") + "的红包"
        msgLabel.text = message
        if robed.isEmpty {
            valueLabel.isHidden = true
        }
        else {
            valueLabel.isHidden = false
            valueLabel.text = BBCurrencyCache.shared.getValueString(cid: cid, value: robed)
        }
    }
}
