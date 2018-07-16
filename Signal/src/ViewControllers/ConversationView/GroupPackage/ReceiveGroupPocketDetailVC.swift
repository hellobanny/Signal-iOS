//
//  ReceiveGroupPocketDetailVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

class ReceiveGroupPocketDetailVC: UIViewController {
    
    var operation:OperationMessage!
    
    convenience init(operation:OperationMessage){
        self.init()
        self.operation = operation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "红包"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ReceiveGroupPocketDetailVC.close))
        
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }

    func loadEnvelopeInfoGet(){
        let request = BBRequestFactory.shared.envelopeInfoGet(eid: operation.transferID)
        TSNetworkManager.shared().makeRequest(request, success: { (task, obj) in
            if let result = obj{
                let (res,_) = BBRequestHelper.parseSuccessResult(object: result)
                if let cus = res {
                    
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

}

extension ReceiveGroupPocketDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "FriendCell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //如果是自己抢的红包，则点击可表示感谢
    }
}
