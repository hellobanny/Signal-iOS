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
    
    var contact:BBContact!
    var operation:OperationMessage!
    
    @objc
    convenience init(contact:BBContact,operation:OperationMessage){
        self.init()
        self.contact = contact
        self.operation = operation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.labelName.text = contact.name
        self.labelMessage.text = "手慢了，红包派完了"
        self.imageViewAvator.image = contact.avatar
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
            //TODO
        }
    }
    
    static func displayRobToLate(home: UIViewController, contact: BBContact, operation: OperationMessage){
        let vc = ReceiveRedPackageVC(contact: contact, operation: operation)
        let pd = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: false, completion: nil)
        home.present(pd, animated: true, completion: nil)
    }

}
