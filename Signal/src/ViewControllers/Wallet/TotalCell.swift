//
//  TotalCell.swift
//  Signal
//
//  Created by 张忠 on 2018/6/25.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class TotalCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var buttonVision: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showOrHideValue(_ sender: Any) {
        
    }
    
    func configWith(currencys:[BBCurrency]){
        self.contentView.backgroundColor = BBCommon.ColorBlack
        self.labelTitle.text = "总资产"
        var sum = 0.0
        for c in currencys{
            sum += c.balance! * c.price!
        }
        self.labelValue.text = BBNumberFT.shared.goodPrice(value: sum)
    }
}
