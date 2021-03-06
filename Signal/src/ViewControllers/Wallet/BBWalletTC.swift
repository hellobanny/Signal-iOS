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
    var pwh:PaywordHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(BBWalletTC.editCurrencyList))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "修改密码(临时)", style: .done, target: self, action: #selector(BBWalletTC.changePayword))
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        let pullView = UIRefreshControl()
        pullView.tintColor = UIColor.gray
        pullView.addTarget(self, action: #selector(BBWalletTC.loadMyCurrencys), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(pullView, at: 0)
        self.pullVC = pullView
        BBCurrencyCache.shared.loadCurrency()
        pwh = PaywordHelper()
        pwh?.checkPaywordInited()
        NotificationCenter.default.addObserver(self, selector: #selector(BBWalletTC.hideWealthChanged), name: NFHiddenCurrency, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NFHiddenCurrency, object: nil)
    }
    
    @objc func hideWealthChanged(){
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        loadMyCurrencys()
        BBCommon.changeNavigationBar(vc: self, isBlack: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func loadMyCurrencys(){
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
    
    @objc func changePayword(){
        pwh?.changePayword()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return currencys.count
        }
        return 1
    }

    private var totalCell:TotalCell?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cellnib = Bundle.main.loadNibNamed("CurrencyCell", owner: self, options: nil)
            let cell = cellnib?.first! as! CurrencyCell
            cell.configWith(currency: currencys[indexPath.row])
            return cell
        }
        else {
            if let tc = totalCell{
                tc.configWith(currencys: self.currencys)
                return tc
            }
            else {
                let cellnib = Bundle.main.loadNibNamed("TotalCell", owner: self, options: nil)
                let cell = cellnib?.first! as! TotalCell
                self.totalCell = cell
                cell.configWith(currencys: self.currencys)
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [0.001,8.0][section]
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 72.0
        }
        return 152.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let currencyDetail = CurrencyDetailVC(cid: currencys[indexPath.row].cid)
            self.navigationController?.pushViewController(currencyDetail, animated: true)
        }
    }

}

