//
//  LuckyGuyCell.swift
//  Signal
//
//  Created by 张忠 on 2018/7/13.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class LuckyGuyCell: UITableViewCell {
    @IBOutlet weak var avatarIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(guy:LuckyGuy,cid:String){
        let url = URL(string: guy.avatarRef)
        avatarIV.kf.setImage(with: url)
        nameLabel.text = guy.name
        valueLabel.text = BBCurrencyCache.shared.getValueString(cid: cid, value: guy.amount)
        noteLabel.text = guy.thanks
        timeLabel.text = BBTimeFT.shared.shortTimeString(time: guy.robTime)
    }
}
