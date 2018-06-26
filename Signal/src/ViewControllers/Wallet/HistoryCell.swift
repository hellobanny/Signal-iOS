//
//  HistoryCell.swift
//  Signal
//
//  Created by 张忠 on 2018/6/26.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValue(value:Double){
        labelValue.textColor = value > 0 ? BBCommon.ColorGreen : BBCommon.ColorBlack
        let str = BBNumberFT.shared.goodNumber(value: value)
        labelValue.text = (value > 0 ? "+ " : "- " ) + str
    }
}
