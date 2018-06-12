//
//  CurrencyCell.swift
//  Signal
//
//  Created by 张忠 on 2018/6/8.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    @IBOutlet weak var avator:UIImageView!
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelPrice:UILabel!
    @IBOutlet weak var labelNumber:UILabel!
    @IBOutlet weak var labelTotal:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
