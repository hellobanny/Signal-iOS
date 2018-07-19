//
//  ReceiveGroupPocketDetailVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class ReceiveGroupPocketDetailVC: UIViewController {
    let BigHeight:CGFloat = 240
    let SmallHeight:CGFloat = 160
    
    @IBOutlet weak var tableView:UITableView!
    
    var groupPocket:GroupPocket!
    
    convenience init(groupPocket:GroupPocket){
        self.init()
        self.groupPocket = groupPocket
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "红包"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ReceiveGroupPocketDetailVC.close))
        
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ReceiveGroupPocketDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : groupPocket.luckyGuys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sec = indexPath.section
        let row = indexPath.row
        if sec == 0 {
            let cellnib = Bundle.main.loadNibNamed("HeadViewCell", owner: self, options: nil)
            let cell = cellnib?.first! as! HeadViewCell
            cell.update(sender: groupPocket.sender, message: groupPocket.message, cid: groupPocket.currency.cid, robed: groupPocket.robed)
            return cell
        }
        else {
            let cellnib = Bundle.main.loadNibNamed("LuckyGuyCell", owner: self, options: nil)
            let cell = cellnib?.first! as! LuckyGuyCell
            if let gp = self.groupPocket {
                let guy = gp.luckyGuys[row]
                cell.config(guy: guy, cid: gp.currency.cid)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        else {
            //没抢完 抢完了
            if groupPocket.count > groupPocket.robCount {
                return "已领取\(groupPocket.robCount)/\(groupPocket.count)个"
            }
            else {
                return "\(groupPocket.count)个红包，已全部抢完"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sec = indexPath.section
        if sec == 0 {
            return groupPocket.robed.isEmpty ? SmallHeight : BigHeight
        }
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //如果是自己抢的红包，则点击可表示感谢
        if indexPath.section == 1 {
            let guy = groupPocket.luckyGuys[indexPath.row]
            if guy.name == OWSProfileManager.shared().localProfileName(){
                let ac = UIAlertController(title: "留言", message: nil, preferredStyle: .alert)
                let save = UIAlertAction(title: "确定", style: .default) { (_) in
                    let tf = ac.textFields![0]
                    let request = BBRequestFactory.shared.envelopeMessageSave(dataId: guy.dataId, message: tf.text ?? "")
                    TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
                        if let result = obj{
                            let code = BBRequestHelper.parseCodeOnly(object: result)
                            if code == BBCommon.NetCodeSuccess {
                                self.groupPocket.luckyGuys[indexPath.row].thanks = tf.text ?? ""
                                self.tableView.reloadRows(at: [indexPath], with: .fade)
                            }
                        }
                    }) { (task, error) in
                        BBRequestHelper.showError(error: error)
                    }
                }
                save.isEnabled = true
                
                let cancel = UIAlertAction(title: "取消", style: .cancel) { (_) in }

                ac.addTextField { (textField) in
                    textField.placeholder = "群成员可见，最多20个字"
                    NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                        if let txt = textField.text {
                            save.isEnabled = !(txt.isEmpty) && txt.lengthOfBytes(using: String.Encoding.utf8) <= 20
                        }
                        else {
                            save.isEnabled = false
                        }
                    }
                }
                ac.addAction(cancel)
                ac.addAction(save)
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
}
