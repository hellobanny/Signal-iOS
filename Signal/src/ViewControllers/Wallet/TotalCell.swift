//
//  TotalCell.swift
//  Signal
//
//  Created by 张忠 on 2018/6/25.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

let NFHiddenCurrency = Notification.Name("NFHiddenCurrency")

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
        let hidden = TotalCell.isHiddenWealth()
        TotalCell.setHiddenWealth(hidden: !hidden)
        updateEyeImage()
        NotificationCenter.default.post(name: NFHiddenCurrency, object: !hidden)
    }
    
    func updateEyeImage(){
        let img = TotalCell.isHiddenWealth() ? UIImage(named: "eyeclose") : UIImage(named: "eyeopen")
        buttonVision.setImage(img, for: .normal)
    }
    
    func configWith(currencys:[BBCurrency]){
        self.contentView.backgroundColor = UIColor.bbNavBlack
        self.labelTitle.text = "总资产"
        if TotalCell.isHiddenWealth() {
            self.labelValue.text = "******"
        }
        else {
            var sum = 0.0
            for c in currencys{
                sum += c.balance! * c.price!
            }
            self.labelValue.text = BBNumberFT.shared.goodPrice(value: sum)
        }
        updateEyeImage()
    }
    
    static func isHiddenWealth() -> Bool{
        return UserDefaults.standard.bool(forKey: NFHiddenCurrency.rawValue)
    }
    
    static func setHiddenWealth(hidden:Bool){
        let ud = UserDefaults.standard
        ud.set(hidden, forKey: NFHiddenCurrency.rawValue)
        ud.synchronize()
    }
}
