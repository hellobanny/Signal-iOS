//
//  WithdrawAddressTC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import PopupDialog

protocol ChooseWithdrawAddressDelegate {
    func chooseWithdraw(address:BBWithdrawAddress)
}

class WithdrawAddressTC: UITableViewController {
    
    var cid:String!
    
    var allAddress = [BBWithdrawAddress]()
    
    var delegate:ChooseWithdrawAddressDelegate?
    
    convenience init(cid:String){
        self.init()
        self.cid = cid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = "选择提币地址"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(WithdrawAddressTC.newAddress))
        loadMyWithdrawAddresss()
    }
    
    @objc func loadMyWithdrawAddresss(){
        let request = BBRequestFactory.shared.withdrawAddress(cid: cid)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,cc) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    if cc == self.cid {
                        self.allAddress = BBWithdrawAddress.addressArrayFrom(json: cus)
                        self.tableView.reloadData()
                    }
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func newAddress(){
        let vc = NewWithdrawAddressVC(nibName: "NewWithdrawAddressVC", bundle: nil)
        let pd = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: false, completion: nil)
        let add = PopupDialogButton(title: "添加") {
            let name = vc.tfName.text ?? ""
            let adds = vc.tfAddress.text ?? ""
            if name.isEmpty || adds.isEmpty{
                return
            }
            self.addNewAddresss(name: name, address: adds)
        }
        let cancel = PopupDialogButton(title: "取消", action: nil)
        pd.addButtons([add,cancel])
        self.present(pd, animated: true, completion: nil)
    }
    
    func addNewAddresss(name:String,address:String){
        let request = BBRequestFactory.shared.withdrawAddressAdd(cid: cid, name: name, address: address)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    let did = cus["dataId"].string!
                    let add = BBWithdrawAddress(dId: did, pname: name, paddress: address)
                    self.allAddress.append(add)
                    self.tableView.insertRows(at: [IndexPath(row: self.allAddress.count - 1, section: 0)], with: .right)
                }
            }
        }) { (task, error) in
            BBRequestHelper.showError(error: error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allAddress.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AddressCell")
        let wa = allAddress[indexPath.row]
        cell.textLabel?.text = wa.name
        cell.detailTextLabel?.text = wa.address
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.chooseWithdraw(address: allAddress[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let add = allAddress.remove(at: indexPath.row)
            let request = BBRequestFactory.shared.withdrawAddressDel(dataId: add.id)
            TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                if let result = obj{
                    BBRequestHelper.parseSuccessResult(object: result)
                }
            }) { (task, error) in
                BBRequestHelper.showError(error: error)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
