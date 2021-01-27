//
//  HomeVC.swift
//  beauty
//
//  Created by cs on 2020/3/3.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import FAPanels
import MBProgressHUD
import SwiftyUserDefaults
import SwiftyJSON
var categoryStatus = 0

class HomeVC: BaseViewController {

    @IBOutlet weak var badgeButton: UIButton!
    @IBOutlet weak var unreadCount: UILabel!
    var menuVC : MenuVC!
    var hud : MBProgressHUD!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        if Defaults[\.userRegistered] {
            getUnreadMessageCount()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfigurations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
        
    }
    
    func viewConfigurations() {

        //  Resetting the Panel Configs...

        panel!.configs = FAPanelConfigurations()
        panel?.leftPanelPosition = .front //.back
        panel!.configs.panFromEdge = false
        panel!.configs.minEdgeForLeftPanel = 40 //CGFloat(Double(sliderValueAsText)!)
        panel!.configs.centerPanelTransitionDuration = 1 //TimeInterval(Double(valueAsText)!)
        //        panel!.configs.rightPanelWidth = 50
        panel!.configs.leftPanelWidth = 150
        panel!.configs.canLeftSwipe = true

        let animOptions: FAPanelTransitionType = .moveLeft
        //        .flipFromLeft, .flipFromRight, .flipFromTop, .flipFromBottom, .curlUp, .curlDown, .crossDissolve
        //        .moveRight, .moveLeft, .moveUp, .moveDown, .splitHorizontally, .splitVertically, .dumpFall, .boxFade,
        panel!.configs.centerPanelTransitionType = animOptions
        panel!.configs.bounceOnRightPanelOpen = false
        panel!.configs.bounceDuration = 0.1

        panel!.delegate = self
    }
    
    func getUnreadMessageCount() {
        
        //self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        //self.hud.show(animated: true)
        CommonApiManager.getUnreadMessageCount(user_id: Defaults[\.userId]!, user_type: userType, completion: {(isSuccess, data) in
            
            if (isSuccess){
                
                let dict = JSON(data as Any)
                let badgeCount = dict["count"].stringValue
                self.unreadCount.text = badgeCount
                if badgeCount == "0" {
                    self.badgeButton.isHidden = true
                    self.unreadCount.isHidden = true
                }else {
                    self.badgeButton.isHidden = false
                    self.unreadCount.isHidden = false
                }
               // self.hud.hide(animated: true)
            }else{
               if data == nil {
                   self.showToast("Failed to connect to server", duration: 2, position: .bottom)
               } else {
                   let result = data as! String
                   if result == "fail" {
                       self.showToast("A user having that eamil does not exist.", duration: 2, position: .bottom)
                   }
                   else {
                       self.showToast("Error", duration: 2, position: .bottom)
                   }
               }
                //self.hud.hide(animated: true)
            }
        })
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
    
    @IBAction func onClickCategories(_ sender: UIButton) {
        
        categoryStatus = sender.tag
        gotoNavVC("ServicesListVC")
    }
    
    @IBAction func onClickNotification(_ sender: Any) {
        gotoNavVC("MessageListVC")
    }
    
}
extension HomeVC: FAPanelStateDelegate {
    
    func centerPanelWillBecomeActive() {
        print("centerPanelWillBecomeActive called")
    }
    
    func centerPanelDidBecomeActive() {
        print("centerPanelDidBecomeActive called")
    }
    
    
    func leftPanelWillBecomeActive() {
        print("leftPanelWillBecomeActive called")
    }
    
    
    func leftPanelDidBecomeActive() {
        print("leftPanelDidBecomeActive called")
    }
    
    
    func rightPanelWillBecomeActive() {
        print("rightPanelWillBecomeActive called")
    }
    
    func rightPanelDidBecomeActive() {
        print("rightPanelDidBecomeActive called")
    }
    
}
