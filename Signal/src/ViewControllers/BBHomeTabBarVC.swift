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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadTabViews()
    }
    
    @objc(loadTabViews)
    public func loadTabViews() {
        let homeView = HomeViewController()
        let homeNav = SignalsNavigationController(rootViewController: homeView)
        let homeBarItem = UITabBarItem(title: "信息", image: UIImage(named: "biMessages"), tag: 0)
        homeNav.tabBarItem = homeBarItem
        
        let contacts  = NewContactThreadViewController()
        let contactsNav = SignalsNavigationController(rootViewController: contacts)
        let contactsBI = UITabBarItem(title: "通讯录", image: UIImage(named: "biContacts"), tag: 1)
        contactsNav.tabBarItem = contactsBI
        
        let walletTC = BBWalletTC(style: .grouped)
        let walletNav = OWSNavigationController(rootViewController: walletTC)
        let coinBagBI = UITabBarItem(title: "钱包", image: UIImage(named: "biBag"), tag: 2)
        walletTC.tabBarItem = coinBagBI
        
        let setNav = AppSettingsViewController.inModalNavigationController()
        let setBarItem = UITabBarItem(title: "我", image: UIImage(named: "biSetting"), tag: 3)
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
