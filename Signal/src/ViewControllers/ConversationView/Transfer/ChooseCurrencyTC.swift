//
//  ChooseCurrencyTC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/29.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

protocol ChooseCurrencyDelegate {
    func userChoose(currency:BBCurrency)
}

class ChooseCurrencyTC: UITableViewController {
    
    var currencys = [BBCurrency]()
    var delegate:ChooseCurrencyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择币种"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ChooseCurrencyTC.close))
        
        currencys = BBCurrencyCache.shared.allCurrencys()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close(){
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CurrencyCell")
        let currency = currencys[indexPath.row]
        let url = URL(string: currency.iconURL)
        cell.imageView?.kf.setImage(with: url)
        cell.textLabel?.text = currency.name
        cell.detailTextLabel?.textColor = UIColor.bbTextLight
        cell.detailTextLabel?.text = "持有量：" + BBNumberFT.shared.goodNumber(value: currency.balance ?? 0.0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cur = currencys[indexPath.row]
        delegate?.userChoose(currency: cur)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
