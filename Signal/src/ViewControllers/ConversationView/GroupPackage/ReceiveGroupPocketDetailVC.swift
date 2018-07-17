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
        if section == 0 {
            return 1
        }
        return groupPocket.luckyGuys.count
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
            return "1/5"
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
    }
}
