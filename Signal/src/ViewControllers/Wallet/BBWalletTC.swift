//
//  BBWalletTC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/8.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class BBWalletTC: UITableViewController {

    var currencys = [BBCurrency]()
    var pullVC : UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(BBWalletTC.editCurrencyList))
        
        loadMyCurrencys()
        
        let pullView = UIRefreshControl()
        pullView.tintColor = UIColor.gray
        pullView.addTarget(self, action: #selector(BBWalletTC.loadMyCurrencys), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(pullView, at: 0)
        self.pullVC = pullView
        BBCurrencyCache.shared.loadCurrency()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func loadMyCurrencys(){
        print("Load my currencys")
        let request = BBRequestFactory.shared.memberCurrency()
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    self.currencys = BBCurrency.currencyArrayFrom(json: cus)
                    self.tableView.reloadData()
                }
            }
            self.pullVC?.endRefreshing()
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
            self.pullVC?.endRefreshing()
        }
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
        return currencys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellnib = Bundle.main.loadNibNamed("CurrencyCell", owner: self, options: nil)
        let cell = cellnib?.first! as! CurrencyCell
        cell.configWith(currency: currencys[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currencyDetail = CurrencyDetailVC(cid: currencys[indexPath.row].cid)
        self.navigationController?.pushViewController(currencyDetail, animated: true)
    }

}
