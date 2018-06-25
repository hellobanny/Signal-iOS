//
//  CurrencyCell.swift
//  Signal
//
//  Created by 张忠 on 2018/6/8.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    func configWith(currency:BBCurrency){
        labelName.textColor = BBCommon.ColorDarkText
        labelNumber.textColor = BBCommon.ColorDarkText
        labelPrice.textColor = BBCommon.ColorLightText
        labelTotal.textColor = BBCommon.ColorLightText
        let url = URL(string: currency.iconURL)
        avator.kf.setImage(with: url)
        labelName.text = currency.name
        labelPrice.text = BBNumberFT.shared.goodPrice(value: currency.price!)
        labelNumber.text = BBNumberFT.shared.goodNumber(value: currency.balance!)
        labelTotal.text = BBNumberFT.shared.goodPrice(value: currency.price! * currency.balance!)
    }
}
