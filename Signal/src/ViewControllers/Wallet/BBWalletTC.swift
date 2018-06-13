//
//  BBWalletTC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/8.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class BBWalletTC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(BBWalletTC.editCurrencyList))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func editCurrencyList(){
        let his = CurrencyListTC(nibName: "CurrencyListTC", bundle: nil)
        let nav = UINavigationController(rootViewController: his)
        self.present(nav, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellnib = Bundle.main.loadNibNamed("CurrencyCell", owner: self, options: nil)
        let cell = cellnib?.first! as! CurrencyCell
        cell.avator.image = UIImage(named: ["btc","eth","bnb"][indexPath.row])
        cell.labelName.text = ["BTC","ETH","BNB"][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currencyDetail = CurrencyDetailVC()
        self.navigationController?.pushViewController(currencyDetail, animated: true)
    }

}
