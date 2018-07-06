//
//  ReceiveRedPackageVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/2.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import PopupDialog

class ReceiveRedPackageVC: UIViewController {
    
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var imageViewAvator: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAction: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var buttonOpen: UIButton!
    
    var contact:BBContact!
    var operation:OperationMessage!
    
    var delegate:TransferAcceptDelegate?
    
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
        self.labelAction.text = "给你发了一个红包"
        self.labelMessage.text = operation.message
        self.imageViewAvator.image = contact.avatar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dialogClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openRedPackage(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.userAccept(operation: self.operation)
        }
    }
    
    static func displayRedPocket(home: UIViewController, delegate: TransferAcceptDelegate, contact: BBContact, operation: OperationMessage){
        let vc = ReceiveRedPackageVC(contact: contact, operation: operation)
        vc.delegate = delegate
        let pd = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: false, completion: nil)
        home.present(pd, animated: true, completion: nil)
    }
    
}
