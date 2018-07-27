//
//  RobToLateVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/12.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import PopupDialog

class RobToLateVC: UIViewController {

    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var imageViewAvator: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var buttonOpenDetail: UIButton!
    
    var groupPocket:GroupPocket!
    var operation:OperationMessage!
    var baseVC:UIViewController?
    
    convenience init(groupPocket:GroupPocket,operation:OperationMessage){
        self.init()
        self.groupPocket = groupPocket
        self.operation = operation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.labelName.text = groupPocket.sender.name
        self.labelName.textColor = UIColor.bbPocketTextLight
        self.labelMessage.text = "手慢了，红包派完了"
        self.labelMessage.textColor = UIColor.bbPocketTextLight
        self.buttonOpenDetail.setTitleColor(UIColor.bbPocketTextLight, for: .normal)
        if let ref = groupPocket.sender.avatarRef {
            let url = URL(string: ref)
            self.imageViewAvator.kf.setImage(with: url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dialogClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewGroupPackageDetail(_ sender: Any) {
        self.dismiss(animated: true) {
            let rv = ReceiveGroupPocketDetailVC(groupPocket: self.groupPocket)
            let nav = UINavigationController(rootViewController: rv)
            self.baseVC?.present(nav, animated: true, completion: nil)
        }
    }
    
    static func displayRobToLate(home: UIViewController, groupPocket: GroupPocket, operation: OperationMessage){
        let vc = RobToLateVC(groupPocket: groupPocket, operation: operation)
        vc.baseVC = home
        let pd = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: true, completion: nil)
        home.present(pd, animated: true, completion: nil)
    }

}
