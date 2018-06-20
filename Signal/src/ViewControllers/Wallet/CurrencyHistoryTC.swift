//
//  CurrencyHistoryTC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import MJRefresh

class CurrencyHistoryTC: UITableViewController {
    
    var cid:String!
    var type:BBHistoryType = .all
    
    var historys = [BBBaseHistory]()
    var lastLoadTime:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.mj_footer = MJRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadHistoryLists))
        loadHistoryLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func loadHistoryLists(){
        let request = BBRequestFactory.shared.memberHis(type: type, cid: cid, time: lastLoadTime, pageSize: BBCommon.PageSize)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    let na = self.type.historyFrom(json: cus)
                    if na.count > 0 {
                        var indexs = [IndexPath]()
                        for i in 0 ..< na.count{
                           indexs.append(IndexPath(row: i + self.historys.count, section: 0))
                        }
                        self.historys.append(contentsOf: na)
                        self.tableView.insertRows(at: indexs, with: .right)
                        self.lastLoadTime = na.last!.pageTime
                    }
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
        return historys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
}
