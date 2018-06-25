//
//  CurrencyListTC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class CurrencyListTC: UITableViewController {
    
    var attentions = [BBCurrency]()
    var unAttentions = [BBCurrency]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CurrencyListTC.done))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CurrencyListTC.cancel))
        self.tableView.isEditing = true
        self.title = "所有币种"
        loadCurrencyLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func done(){
        var cids = ""
        for cc in attentions{
            if !cids.isEmpty {
                cids.append(",")
            }
            cids.append(cc.cid)
        }
        let request = BBRequestFactory.shared.currencyAttention(cids: cids)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            self.dismiss(animated: true, completion: nil)
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }
    
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadCurrencyLists(){
        let request = BBRequestFactory.shared.platformCurrency()
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    let array = BBCurrency.currencyArrayFrom(json: cus)
                    self.attentions.removeAll()
                    self.unAttentions.removeAll()
                    for cc in array{
                        if cc.isAttention {
                            self.attentions.append(cc)
                        }
                        else{
                            self.unAttentions.append(cc)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? attentions.count : unAttentions.count
    }

    func currencyFrom(index:IndexPath) -> BBCurrency{
        if index.section == 0 {
            return attentions[index.row]
        }
        else{
            return unAttentions[index.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CurrencyCell")
        let cc = currencyFrom(index: indexPath)
        cell.textLabel?.text = cc.name
        //cell.detailTextLabel?.text = BBNumberFT.shared.goodNumber(value: cc.balance ?? 0.0)
        let url = URL(string: cc.iconURL)
        cell.imageView?.kf.setImage(with: url)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["关注币种列表","未关注币种列表"][section]
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "上下移动位置可调整顺序"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
 
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //update array after move
        let s1 = sourceIndexPath.section
        let s2 = destinationIndexPath.section
        let r1 = sourceIndexPath.row
        let r2 = destinationIndexPath.row
        if s1 == 0 && s2 == 0 {
            let cc = attentions.remove(at: r1)
            attentions.insert(cc, at: r2)
        }
        else if s1 == 1 && s2 == 0 {
            let cc = unAttentions.remove(at: r1)
            attentions.insert(cc, at: r2)
        }
        else if s1 == 0 && s2 == 1 {
            let cc = attentions.remove(at: r1)
            unAttentions.insert(cc, at: r2)
        }
        else {
            let cc = unAttentions.remove(at: r1)
            unAttentions.insert(cc, at: r2)
        }
    }
}
