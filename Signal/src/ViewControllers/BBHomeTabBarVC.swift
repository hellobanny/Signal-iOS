//
//  BBHomeTabBarVC.swift
//  Signal
//
//  Created by 张忠 on 2018/6/8.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit

@objc class BBHomeTabBarVC: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        UITabBar.appearance().tintColor = BBCommon.ColorGreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadTabViews()
    }
    
    @objc(loadTabViews)
    public func loadTabViews() {
        let homeView = HomeViewController()
        let homeNav = SignalsNavigationController(rootViewController: homeView)
        let homeBarItem = UITabBarItem(title: "信息", image: UIImage(named: "message-grey"), tag: 0)
        homeBarItem.selectedImage = UIImage(named: "message")
        homeNav.tabBarItem = homeBarItem
        
        let contacts  = NewContactThreadViewController()
        let contactsNav = SignalsNavigationController(rootViewController: contacts)
        let contactsBI = UITabBarItem(title: "通讯录", image: UIImage(named: "addressbook-grey"), tag: 1)
        contactsBI.selectedImage = UIImage(named: "address-book")
        contactsNav.tabBarItem = contactsBI
        
        let walletTC = BBWalletTC(style: .plain)
        let walletNav = OWSNavigationController(rootViewController: walletTC)
        let coinBagBI = UITabBarItem(title: "钱包", image: UIImage(named: "wallet-grey"), tag: 2)
        coinBagBI.selectedImage = UIImage(named: "wallet")
        walletTC.tabBarItem = coinBagBI
        
        let setNav = AppSettingsViewController.inModalNavigationController()
        let setBarItem = UITabBarItem(title: "我", image: UIImage(named: "my-grey"), tag: 3)
        setBarItem.selectedImage = UIImage(named: "my")
        setNav.tabBarItem = setBarItem
        
        self.viewControllers = [homeNav,contactsNav,walletNav,setNav]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("1")
    }
}
